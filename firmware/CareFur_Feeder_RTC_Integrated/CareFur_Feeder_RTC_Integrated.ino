#include <WiFi.h>
#include <WiFiClientSecure.h>
#include <HTTPClient.h>
#include <ArduinoJson.h>
#include <Preferences.h>
#include <Wire.h>
#include <RTClib.h>
#include <time.h>
#include "HX711.h"
#include "CareFurWiFiPortal.h"
// =====================================================
// CONFIGURATION — replace these three values
// =====================================================
// Set a new, rotated device secret matching your deployed Supabase function.
// Keep this secret private; never place it in frontend dashboard code.
const char* DEVICE_SECRET = "SET_TO_SUPABASE_DEVICE_SECRET";
// Use portal instead of hardcoded router Wi-Fi credentials.
const char* SETUP_AP_PASSWORD = "CHANGE_THIS_AP_PASSWORD";
// MUST match camera firmware. Generate random 24+ characters; NOT your router password.
const char* CAMERA_PAIR_KEY = "CHANGE_TO_SAME_RANDOM_KEY_AS_CAMERA";
// Your existing deployed ESP32 endpoint.
const char* FUNCTION_URL =
  "https://iswstisiecdtadtwnpkj.supabase.co/functions/v1/feeder-rotate";
const char* DEVICE_CODE = "carefur-feeder-01";
// Same Supabase project; separate status endpoint from motor command polling.
const char* WIFI_STATUS_URL =
  "https://iswstisiecdtadtwnpkj.supabase.co/functions/v1/feeder-wifi-status";

const char* FOOD_TELEMETRY_URL =
  "https://iswstisiecdtadtwnpkj.supabase.co/functions/v1/feeder-food-telemetry";
// Post one fresh load-cell measurement roughly every three seconds.
// Keep this slower than the 250 ms local serial stream.
constexpr unsigned long FOOD_TELEMETRY_INTERVAL_MS = 3000;
constexpr unsigned long FOOD_SAMPLE_MAX_AGE_MS = 1500;
unsigned long lastFoodTelemetryAt = 0;
unsigned long lastFoodTelemetryErrorAt = 0;
unsigned long lastValidFoodSampleAt = 0;
float latestFoodWeightG = 0.0f;
bool foodTelemetrySampleReady = false;
constexpr unsigned long WIFI_REPORT_INTERVAL_MS = 3000;
constexpr unsigned long WIFI_SWITCH_POLL_MS = 8000;
unsigned long lastWiFiSwitchPoll = 0;
unsigned long lastWiFiReport = 0;
bool wifiReportOnce = false;
// =====================================================
// YOUR WORKING HARDWARE PINS
// =====================================================
constexpr int NEMA_STEP_PIN = 33;
constexpr int NEMA_DIR_PIN = 26;
constexpr int LIMIT_SWITCH_PIN = 27; // NO->GPIO27, COM->GND
constexpr int BUTTON_PIN = 32;          // Push button between GPIO32 and GND
constexpr int HX711_DT = 16;
constexpr int HX711_SCK = 13;
// DS3231 RTC: VCC=3V3, GND=GND, SDA=21, SCL=22
constexpr int RTC_SDA_PIN = 21;
constexpr int RTC_SCL_PIN = 22;
const char* RTC_CONFIG_URL = "https://iswstisiecdtadtwnpkj.supabase.co/functions/v1/feeder-rtc-config";
// CRITICAL: false = SAFE dry-run; no physical offline dispensing.
// Set true ONLY after calibrating home and each real compartment on hardware,
// and disabling ALL cloud auto-feeding cron schedules for this motor.
constexpr bool RTC_ALLOW_MOTOR_DISPENSING = false;
constexpr unsigned long RTC_SYNC_INTERVAL_MS = 60000;
constexpr unsigned long RTC_SCHEDULE_CHECK_MS = 1000;


constexpr unsigned long POLL_INTERVAL_MS = 3000;
constexpr unsigned long BUTTON_LOCKOUT_MS = 350;
constexpr unsigned long WEIGHT_INTERVAL_MS = 250;
constexpr uint32_t NEMA_PULSE_PERIOD_US = 3000; // 1500us HIGH + 1500us LOW
constexpr int NEMA_STEPS_120 = 533; // Calibrate for YOUR microstep configuration
// Automatically home on startup. CAUTION: motor will move when powered on.
constexpr bool AUTO_HOME_ON_BOOT = true;
constexpr bool HOME_CLOCKWISE = false; // REVERSED: homing rotates in opposite direction (CCW)
constexpr uint32_t HOME_HALF_PERIOD_US = 3500; // 7ms per pulse, slower than feeding
constexpr int HOME_MAX_STEPS = 2200;           // adjust to <= ~one revolution + margin
constexpr unsigned long HOME_TIMEOUT_MS = 25000;
constexpr unsigned long HOME_DEBOUNCE_MS = 25;
constexpr unsigned long HOME_EXTRA_ROTATION_MS = 450; // Continue stepping 450 ms after confirmed switch press


// Initial measured calibration: plate-only to plate + 500 g.
// Recheck using known masses and update if necessary.
constexpr float HX711_CALIBRATION_FACTOR = -418.3f;
float hxFiltered = 0.0f;
bool hxFilterInitialized = false;
bool weightStreaming = true;
bool hxBaselineSet = false;
long hxBaseline = 0;
// Saved in ESP32 NVS only when manually tared (Z). Never zero on every boot.
constexpr const char* HX711_TARE_NVS_KEY = "hx_zero";
long hxLastRaw = 0;
bool hxHasValidSample = false;
unsigned long lastWeightAt = 0;
unsigned long lastWeightWarningAt = 0;

// Food activity sensing. "g" values are approximate; detects LOAD CHANGES,
// not proof of eating. Thresholds may need adjustment for bowl vibration.
constexpr float FOOD_PRESENT_THRESHOLD_G = 8.0f;
constexpr float FOOD_EMPTY_THRESHOLD_G = 3.0f;
constexpr float FOOD_REMOVAL_THRESHOLD_G = 5.0f;
constexpr unsigned long FOOD_CONFIRM_MS = 2000;
constexpr unsigned long FOOD_STABLE_MS = 3000;
constexpr unsigned long MOTOR_SETTLE_MS = 3000;

bool foodPresent = false;
bool foodStableReported = false;
float foodReferenceG = 0.0f;
unsigned long foodPresentSinceMs = 0;
unsigned long foodEmptySinceMs = 0;
unsigned long foodDecreaseSinceMs = 0;
unsigned long foodLastChangeMs = 0;
unsigned long motorLastStoppedMs = 0;

void resetFoodDetection() {
  foodPresent = false;
  foodStableReported = false;
  foodReferenceG = 0.0f;
  foodPresentSinceMs = 0;
  foodEmptySinceMs = 0;
  foodDecreaseSinceMs = 0;
  foodLastChangeMs = 0;
}

// Forward declaration: motor state is defined later in this sketch.
extern volatile bool nemaBusy;

void updateFoodDetection(float loadG) {
  if (!hxBaselineSet || !hxHasValidSample) return;
  const unsigned long nowMs = millis();
  // Motor movement/vibration must not register as feeding activity.
  if (nemaBusy || nowMs - motorLastStoppedMs < MOTOR_SETTLE_MS) {
    foodPresentSinceMs = 0;
    foodEmptySinceMs = 0;
    foodDecreaseSinceMs = 0;
    foodStableReported = false;
    return;
  }

  if (!foodPresent) {
    if (loadG >= FOOD_PRESENT_THRESHOLD_G) {
      if (!foodPresentSinceMs) foodPresentSinceMs = nowMs;
      if (nowMs - foodPresentSinceMs >= FOOD_CONFIRM_MS) {
        foodPresent = true;
        foodReferenceG = loadG;
        foodLastChangeMs = nowMs;
        foodPresentSinceMs = 0;
        Serial.println("[FOOD] FOOD DETECTED - monitoring load changes");
      }
    } else {
      foodPresentSinceMs = 0;
    }
    return;
  }

  // A near-empty load must persist to avoid false EMPTY signals.
  if (loadG <= FOOD_EMPTY_THRESHOLD_G) {
    if (!foodEmptySinceMs) foodEmptySinceMs = nowMs;
    if (nowMs - foodEmptySinceMs >= FOOD_CONFIRM_MS) {
      resetFoodDetection();
      Serial.println("[FOOD] PLATE EMPTY - load returned near baseline");
    }
    return;
  }
  foodEmptySinceMs = 0;

  // Track food additions so a later decrease is compared to latest load.
  if (loadG > foodReferenceG + FOOD_REMOVAL_THRESHOLD_G) {
    foodReferenceG = loadG;
    foodDecreaseSinceMs = 0;
    foodLastChangeMs = nowMs;
    foodStableReported = false;
    Serial.println("[FOOD] LOAD INCREASED - reference updated");
    return;
  }

  // Sustained drop from last recorded reference suggests food removal.
  if (foodReferenceG - loadG >= FOOD_REMOVAL_THRESHOLD_G) {
    if (!foodDecreaseSinceMs) foodDecreaseSinceMs = nowMs;
    if (nowMs - foodDecreaseSinceMs >= FOOD_CONFIRM_MS) {
      Serial.printf("[FOOD] POSSIBLE EATING - sustained load decrease (~%.1f g equivalent)\n",
                    foodReferenceG - loadG);
      foodReferenceG = loadG;
      foodLastChangeMs = nowMs;
      foodDecreaseSinceMs = 0;
      foodStableReported = false;
    }
  } else {
    foodDecreaseSinceMs = 0;
    if (!foodStableReported && nowMs - foodLastChangeMs >= FOOD_STABLE_MS) {
      foodStableReported = true;
      Serial.println("[FOOD] FOOD STABLE");
    }
  }
}

// Interrupt records presses even while an HTTPS request blocks loop().
volatile uint32_t buttonPressCount = 0;
volatile uint32_t lastButtonIRQus = 0;
uint32_t handledButtonCount = 0;
unsigned long lastButtonActionAt = 0;
unsigned long lastButtonDiagnosticAt = 0;
bool buttonDiagnostic = false;
bool suppressButtonUntilReleased = false;

String pendingCommandId = "";
bool pendingFailure = false;
bool nemaFinished = false;

void ARDUINO_ISR_ATTR onButtonFalling() {
  uint32_t now = micros();
  if ((uint32_t)(now - lastButtonIRQus) >= 60000UL) {
    buttonPressCount++;
    lastButtonIRQus = now;
  }
}

// NEMA17 stepper and home sensor. One cam/switch activation per revolution.
// Software-only stopping cannot remove power from the driver.
volatile bool nemaBusy = false;
int nemaStepsRemaining = 0;
bool nemaPulseHigh = false;
uint32_t nemaLastEdgeUs = 0;
uint32_t activeHalfPeriodUs = NEMA_PULSE_PERIOD_US / 2;
int moveStepCount = 0;
bool moveClockwise = true;
bool homing = false;
bool homed = false;
int compartmentIndex = -1; // 0 = HOME, 1 = +120deg, 2 = +240deg
int homingSteps = 0;
unsigned long homingStartMs = 0;
unsigned long homeLowSinceMs = 0;
bool homeExtraRotation = false;
unsigned long homeExtraStartMs = 0;

bool homePressed() { return digitalRead(LIMIT_SWITCH_PIN) == LOW; }

void stopNema() {
  nemaBusy = false;
  nemaStepsRemaining = 0;
  nemaPulseHigh = false;
  nemaFinished = false;
  digitalWrite(NEMA_STEP_PIN, LOW);
  motorLastStoppedMs = millis();
}

void homeFailed(const char* why) {
  stopNema();
  homing = false;
  homed = false;
  compartmentIndex = -1;
  if (pendingCommandId.length()) pendingFailure = true;
  Serial.printf("[HOME] FAILED: %s. Feeding locked; inspect switch/mechanism.\n", why);
}

bool startHome() {
  if (nemaBusy || homing || pendingCommandId.length()) return false;
  homed = false;
  compartmentIndex = -1;
  homeLowSinceMs = 0;
  homeExtraRotation = false;
  homeExtraStartMs = 0;
  homingSteps = 0;
  homingStartMs = millis();
  if (homePressed()) {
    // A pressed switch on boot might be genuine home or stuck wiring.
    // Require a stable press; operator should confirm mechanics before enabling automatic homing.
    homeLowSinceMs = millis();
  }
  digitalWrite(NEMA_DIR_PIN, HOME_CLOCKWISE ? HIGH : LOW);
  digitalWrite(NEMA_STEP_PIN, LOW);
  nemaPulseHigh = false;
  nemaLastEdgeUs = micros();
  activeHalfPeriodUs = HOME_HALF_PERIOD_US;
  homing = true;
  nemaBusy = true;
  Serial.println("[HOME] Slowly searching for switch (GPIO27)...");
  return true;
}

bool startNema(int steps, bool clockwise) {
  if (!homed) { Serial.println("[NEMA17] HOME required. Send G first."); return false; }
  if (nemaBusy || homing || pendingCommandId.length() || steps <= 0 || steps > 10000) return false;
  nemaFinished = false;
  digitalWrite(NEMA_DIR_PIN, clockwise ? HIGH : LOW);
  digitalWrite(NEMA_STEP_PIN, LOW);
  nemaStepsRemaining = steps;
  moveStepCount = steps;
  moveClockwise = clockwise;
  nemaPulseHigh = false;
  nemaLastEdgeUs = micros();
  activeHalfPeriodUs = NEMA_PULSE_PERIOD_US / 2;
  nemaBusy = true;
  Serial.printf("[NEMA17] %s, %d pulses\n", clockwise ? "CW" : "CCW", steps);
  return true;
}

void tickNema() {
  if (!nemaBusy) return;
  if (homing) {
    const unsigned long nowMs = millis();
    if (nowMs - homingStartMs >= HOME_TIMEOUT_MS) {
      homeFailed("timeout");
      return;
    }

    if (!homeExtraRotation) {
      if (homePressed()) {
        if (homeLowSinceMs == 0) homeLowSinceMs = nowMs;
        if (nowMs - homeLowSinceMs >= HOME_DEBOUNCE_MS) {
          homeExtraRotation = true;
          homeExtraStartMs = nowMs;
          Serial.println("[HOME] Switch confirmed; continuing rotation for 450 ms...");
        } else if (!nemaPulseHigh) {
          // Confirm the press without adding steps during debounce.
          return;
        }
      } else {
        homeLowSinceMs = 0;
      }
      if (!homeExtraRotation && homingSteps >= HOME_MAX_STEPS && !nemaPulseHigh) {
        homeFailed("travel limit reached without switch");
        return;
      }
    }

    // Complete a HIGH pulse before stopping, and keep the step count accurate.
    if (homeExtraRotation &&
        nowMs - homeExtraStartMs >= HOME_EXTRA_ROTATION_MS &&
        !nemaPulseHigh) {
      stopNema();
      homing = false;
      homeExtraRotation = false;
      homed = true;
      compartmentIndex = 0;
      if (pendingCommandId.length()) nemaFinished = true;
      Serial.println("[HOME] Completed 450-ms extra rotation; saved as position 1 reference.");
      return;
    }
  }
  uint32_t now = micros();
  if ((uint32_t)(now - nemaLastEdgeUs) < activeHalfPeriodUs) return;
  nemaLastEdgeUs = now;
  if (!nemaPulseHigh) {
    digitalWrite(NEMA_STEP_PIN, HIGH);
    nemaPulseHigh = true;
  } else {
    digitalWrite(NEMA_STEP_PIN, LOW);
    nemaPulseHigh = false;
    if (homing) {
      ++homingSteps;
    } else if (--nemaStepsRemaining <= 0) {
      nemaBusy = false;
      motorLastStoppedMs = millis();
      if (moveStepCount == NEMA_STEPS_120 && compartmentIndex >= 0) {
        compartmentIndex = (compartmentIndex + (moveClockwise ? 1 : 2)) % 3;
        Serial.printf("[INDEX] Estimated compartment position: %d\n", compartmentIndex + 1);
      } else {
        homed = false;
        compartmentIndex = -1;
        Serial.println("[INDEX] Non-120-degree move; re-home required");
      }
      nemaFinished = true;
      suppressButtonUntilReleased = digitalRead(BUTTON_PIN) == LOW;
      Serial.println("[NEMA17] Pulse sequence completed (physical position not sensor-verified)");
    }
  }
}

HX711 scale;
Preferences preferences;
CareFurWiFiPortal wifiPortal("CareFur-Feeder-Setup", SETUP_AP_PASSWORD, 80);
bool storageReady = false;
bool endpointReady = false;
// Remote dashboard polling is enabled automatically on boot.
// Serial command D can disable it; A can enable it again.
bool remoteEnabled = true;
unsigned long lastPoll = 0;
String lastCommandId = "";
// =====================================================
// OFFLINE DS3231 CONFIGURATION AND SCHEDULING
// =====================================================
RTC_DS3231 rtc;
bool rtcPresent = false;
bool rtcClockValid = false;
bool rtcEnabled = false;
int rtcMealHour[3] = {8,13,19};
int rtcMealMinute[3] = {0,0,0};
uint32_t rtcConfigVersion = 0;
uint32_t rtcLastDay[3] = {0,0,0};
unsigned long lastRtcSync = 0;
unsigned long lastRtcCheck = 0;
unsigned long lastRtcClockSync = 0;
bool rtcSyncAttempted = false;
int rtcMoveSegmentsLeft = 0;
int rtcActiveMeal = -1;

bool parseRtcTime(const String& input, int& hourOut, int& minuteOut) {
  if(input.length()<5 || input[2]!=':') return false;
  for(int i : {0,1,3,4}) if(input[i]<'0' || input[i]>'9') return false;
  int h=input.substring(0,2).toInt(), m=input.substring(3,5).toInt();
  if(h>23 || m>59) return false;
  hourOut=h; minuteOut=m; return true;
}

uint32_t rtcDayKey(const DateTime& t) {
  return (uint32_t)t.year()*10000UL+(uint32_t)t.month()*100UL+(uint32_t)t.day();
}

void loadRtcConfig() {
  if(!storageReady)return;
  rtcEnabled=preferences.getBool("rt_on",false);
  rtcConfigVersion=preferences.getUInt("rt_ver",0);
  const int defaultsH[3]={8,13,19};
  for(int i=0;i<3;i++){
    String k=String("rt_t")+String(i+1);
    String saved=preferences.getString(k.c_str(),"");
    int h=defaultsH[i],m=0;
    parseRtcTime(saved,h,m);
    rtcMealHour[i]=h;rtcMealMinute[i]=m;
    String dayKey=String("rt_d")+String(i+1);
    rtcLastDay[i]=preferences.getUInt(dayKey.c_str(),0);
  }
}

void setupRtc() {
  Wire.begin(RTC_SDA_PIN,RTC_SCL_PIN);
  rtcPresent=rtc.begin();
  if(!rtcPresent){Serial.println("[RTC] DS3231 not detected; offline schedule DISABLED");return;}
  rtcClockValid=!rtc.lostPower();
  if(rtcClockValid){
    DateTime n=rtc.now();
    rtcClockValid=n.year()>=2024 && n.year()<=2099;
  }
  if(!rtcClockValid)Serial.println("[RTC] Date invalid or battery lost; needs NTP/serial clock sync; feeding BLOCKED");
  else Serial.println("[RTC] DS3231 clock valid (must be set to Asia/Manila time)");
}

void syncRtcClockFromNtp() {
  if(!rtcPresent||!wifiPortal.connected())return;
  if(millis()-lastRtcClockSync<60000 && lastRtcClockSync!=0)return;
  lastRtcClockSync=millis();
  // NTP is used only to initialize a lost-power clock; avoids resetting a running RTC.
  if(rtcClockValid)return;
  configTime(0,0,"pool.ntp.org","time.google.com");
  time_t epoch=time(nullptr);
  if(epoch<1700000000)return;
  // DS3231 stores Philippine wall-clock time (fixed UTC+8, no DST).
  rtc.adjust(DateTime((uint32_t)epoch+8UL*3600UL));
  rtcClockValid=true;
  Serial.println("[RTC] Recovered RTC clock from NTP (Philippine local time)");
}

bool syncRtcSchedule() {
  if(!storageReady||!wifiPortal.connected()||nemaBusy||homing||pendingCommandId.length()||rtcMoveSegmentsLeft)return false;
  WiFiClientSecure client;
  // This inherited firmware uses insecure TLS; replace with trusted CA before production.
  client.setInsecure();
  HTTPClient http;
  if(!http.begin(client,RTC_CONFIG_URL))return false;
  http.setTimeout(5000);
  http.addHeader("Content-Type","application/json");
  http.addHeader("x-device-secret",DEVICE_SECRET);
  JsonDocument request;request["action"]="device_sync";request["device_code"]=DEVICE_CODE;
  String body;serializeJson(request,body);
  int code=http.POST(body);
  String response=code==200?http.getString():"";
  http.end();
  if(code!=200){Serial.printf("[RTC SYNC] HTTP %d (cached schedule retained)\n",code);return false;}
  JsonDocument parsed;
  if(deserializeJson(parsed,response)||!(parsed["ok"]|false)||!parsed["config"].is<JsonObject>())return false;
  JsonObject cfg=parsed["config"].as<JsonObject>();
  int h[3],m[3];
  const char* keys[]={"morning_time","afternoon_time","evening_time"};
  for(int i=0;i<3;i++)if(!parseRtcTime(cfg[keys[i]].as<String>(),h[i],m[i]))return false;
  bool enabled=cfg["enabled"]|false;
  uint32_t version=cfg["version"]|0;
  if(version<rtcConfigVersion)return false; // prevent accidentally applying older configuration
  // Save all values before enabling RTC scheduling, so power cycling restores them.
  for(int i=0;i<3;i++){
    String key=String("rt_t")+String(i+1);
    char timeBuf[6];snprintf(timeBuf,sizeof(timeBuf),"%02d:%02d",h[i],m[i]);
    preferences.putString(key.c_str(),timeBuf);
  }
  preferences.putUInt("rt_ver",version);
  preferences.putBool("rt_on",enabled);
  for(int i=0;i<3;i++){rtcMealHour[i]=h[i];rtcMealMinute[i]=m[i];}
  rtcConfigVersion=version;rtcEnabled=enabled;
  Serial.printf("[RTC SYNC] Saved v%lu, enabled=%d. Morning=%02d:%02d, afternoon=%02d:%02d, evening=%02d:%02d\n",
    (unsigned long)version,enabled,h[0],m[0],h[1],m[1],h[2],m[2]);
  return true;
}

void finishRtcMotorSegment() {
  if(rtcMoveSegmentsLeft<=0)return;
  if(!homed||compartmentIndex<0){
    rtcMoveSegmentsLeft=0;rtcActiveMeal=-1;
    Serial.println("[RTC] Motor lost reference. Remaining feed motion cancelled.");
    return;
  }
  --rtcMoveSegmentsLeft;
  if(rtcMoveSegmentsLeft>0){
    if(!startNema(NEMA_STEPS_120,true)){
      rtcMoveSegmentsLeft=0;rtcActiveMeal=-1;
      Serial.println("[RTC] Could not continue compartment indexing");
    }
  }else{
    Serial.printf("[RTC] Position reached, meal %d; DISPENSE NOT SENSOR-CONFIRMED\n",rtcActiveMeal+1);
    rtcActiveMeal=-1;
  }
}

// Built-in non-dispensing diagnostic for the same firmware (Serial K).
// Reads current DS3231 time and cached daily schedule without modifying
// the execution ledger, motor state, or stored settings.
void testRtcScheduleDryRun() {
  Serial.println("\n[RTC TEST] Integrated offline schedule diagnostic (NO MOTOR ACTION)");
  Serial.printf("[RTC TEST] Device present=%s | clock valid=%s | schedule enabled=%s | motor allowed=%s\n",
    rtcPresent ? "YES" : "NO", rtcClockValid ? "YES" : "NO",
    rtcEnabled ? "YES" : "NO", RTC_ALLOW_MOTOR_DISPENSING ? "YES" : "NO");
  if (!rtcPresent || !rtcClockValid) {
    Serial.println("[RTC TEST] DS3231 unavailable/invalid; scheduled feeding is blocked.");
    return;
  }
  DateTime current = rtc.now();
  uint32_t today = rtcDayKey(current);
  Serial.printf("[RTC TEST] Current PH time: %04d-%02d-%02d %02d:%02d:%02d\n",
    current.year(),current.month(),current.day(),current.hour(),current.minute(),current.second());
  const char* meals[3] = {"Morning", "Afternoon", "Evening"};
  for (int i=0; i<3; ++i) {
    int due = rtcMealHour[i]*60 + rtcMealMinute[i];
    int nowMinutes = current.hour()*60 + current.minute();
    bool inWindow = nowMinutes >= due && nowMinutes <= due+1;
    Serial.printf("[RTC TEST] %s -> compartment %d, %02d:%02d, already attempted today=%s, due now=%s\n",
      meals[i], i+1, rtcMealHour[i], rtcMealMinute[i],
      rtcLastDay[i] == today ? "YES" : "NO", inWindow ? "YES" : "NO");
  }
  Serial.println("[RTC TEST] No motor pulses, no NVS writes, no schedule change.");
}

void checkRtcFeeding() {
  if(!rtcEnabled||!rtcPresent||!rtcClockValid||!storageReady)return;
  if(millis()-lastRtcCheck<RTC_SCHEDULE_CHECK_MS)return;
  lastRtcCheck=millis();
  if(nemaBusy||homing||pendingCommandId.length()||rtcMoveSegmentsLeft>0)return;
  DateTime now=rtc.now();
  if(now.year()<2024||now.year()>2099)return;
  uint32_t today=rtcDayKey(now);
  for(int i=0;i<3;i++){
    // Trigger within a 2-minute window; do not dispense hours late after reboot.
    int delta=(int)now.hour()*60+(int)now.minute()-(rtcMealHour[i]*60+rtcMealMinute[i]);
    if(delta<0||delta>1||rtcLastDay[i]==today)continue;
    if(!RTC_ALLOW_MOTOR_DISPENSING){
      Serial.printf("[RTC DRY RUN] Meal %d / compartment %d due at %02d:%02d; motor DISABLED\n",i+1,i+1,rtcMealHour[i],rtcMealMinute[i]);
      String key=String("rt_d")+String(i+1);
      if(preferences.putUInt(key.c_str(),today)==sizeof(uint32_t))rtcLastDay[i]=today;
      return;
    }
    if(!homed||compartmentIndex<0){Serial.println("[RTC] NOT HOMED; feed blocked");return;}
    const int target=i; // 0=compartment1, 1=compartment2, 2=compartment3.
    int segments=(target-compartmentIndex+3)%3;
    if(segments==0)segments=3; // complete rotation; never silently treat same position as dispensing.
    // Persist before movement to avoid double-feeding after power loss.
    String key=String("rt_d")+String(i+1);
    if(preferences.putUInt(key.c_str(),today)!=sizeof(uint32_t)){
      Serial.println("[RTC] Cannot persist daily lock; feeding blocked");return;
    }
    rtcLastDay[i]=today;
    rtcMoveSegmentsLeft=segments;
    rtcActiveMeal=i;
    if(!startNema(NEMA_STEPS_120,true)){
      rtcMoveSegmentsLeft=0;rtcActiveMeal=-1;
      Serial.println("[RTC] Could not start motor; no automatic retry to prevent duplicates");
    }else Serial.printf("[RTC] Meal %d started (%d x 120deg calibrated steps)\n",i+1,segments);
    return;
  }
}

// =====================================================
// WIFI
// =====================================================
bool connectWiFi() {
  // Never repeatedly block or restart Wi-Fi during automatic polling.
  // wifiPortal.loop() handles reconnecting / fallback setup hotspot.
  if (wifiPortal.connected()) return true;
  endpointReady = false;
  return false;
}
// =====================================================
// HTTPS — TEMPORARY CERTIFICATE BYPASS
// =====================================================
bool sendRequest(
  JsonDocument& request,
  JsonDocument& response
) {
  if (!connectWiFi()) return false;
  WiFiClientSecure client;
  // TEMPORARY TEST ONLY: Replace setInsecure with verified Root CA for production.
  // The device secret alone does not protect against impersonated servers.
  // TEMPORARY TEST ONLY:
  // HTTPS encryption remains enabled, but the server's
  // identity and certificate chain are not verified.
  client.setInsecure();
  client.setHandshakeTimeout(15);
  HTTPClient http;
  if (!http.begin(client, FUNCTION_URL)) {
    Serial.println("Could not initialize HTTPS.");
    return false;
  }
  http.setTimeout(15000);
  http.addHeader("Content-Type", "application/json");
  http.addHeader("x-device-secret", DEVICE_SECRET);
  String payload;
  serializeJson(request, payload);
  int status = http.POST(payload);
  if (status <= 0) {
    Serial.print("HTTPS connection error: ");
    Serial.println(http.errorToString(status));
    http.end();
    return false;
  }
  String body = http.getString();
  http.end();
  Serial.print("HTTP status: ");
  Serial.println(status);
  if (status < 200 || status >= 300) {
    Serial.print("Server response: ");
    Serial.println(body);
    return false;
  }
  response.clear();
  DeserializationError parseError =
    deserializeJson(response, body);
  if (parseError) {
    Serial.print("JSON error: ");
    Serial.println(parseError.c_str());
    return false;
  }
  if (!(response["ok"] | false)) {
    Serial.print("Server rejected request: ");
    Serial.println(response["error"] | "Unknown server error");
    return false;
  }
  return true;
}
// =====================================================
// TEST THE EXISTING SUPABASE FUNCTION
// =====================================================
bool testConnection() {
  endpointReady = false;
  Serial.println("\n========================");
  Serial.println("SUPABASE CONNECTION TEST");
  Serial.println("Certificate verification DISABLED");
  Serial.println("========================");
  JsonDocument request;
  JsonDocument response;
  request["action"] = "ping";
  request["device_code"] = DEVICE_CODE;
  endpointReady = sendRequest(request, response);
  Serial.println(
    endpointReady
      ? "Supabase connection successful."
      : "Supabase connection failed."
  );
  return endpointReady;
}
// =====================================================
// AUTOMATIC WI-FI HEARTBEAT (does not send saved passwords)
// =====================================================
void reportWiFiStatus() {
  if (!wifiPortal.connected() || nemaBusy || homing || pendingCommandId.length()) return; // avoid blocking active stepping
  JsonDocument status;
  status["action"] = "report";
  status["device_code"] = DEVICE_CODE;
  status["connected"] = true;
  status["connected_ssid"] = WiFi.SSID();
  status["saved_ssid"] = wifiPortal.savedNetwork();
  status["ip_address"] = WiFi.localIP().toString();
  status["rssi"] = WiFi.RSSI();
  status["paused"] = wifiPortal.isPaused();
  JsonArray saved = status["saved_networks"].to<JsonArray>();
  wifiPortal.addSavedNetworks(saved);
  String json;
  serializeJson(status, json);
  WiFiClientSecure client;
  // IMPORTANT: Replace with certificate verification before production use.
  // This preserves the existing sketch's temporary TLS setting.
  client.setInsecure();
  client.setHandshakeTimeout(10);
  HTTPClient http;
  if (!http.begin(client, WIFI_STATUS_URL)) return;
  http.setTimeout(8000);
  http.addHeader("Content-Type", "application/json");
  http.addHeader("x-device-secret", DEVICE_SECRET);
  const int httpCode = http.POST(json);
  if (httpCode != 200) {
    Serial.printf("Wi-Fi heartbeat failed: HTTP %d\n", httpCode);
  }
  http.end();
}
// Switch remotely only between networks whose credentials are ALREADY stored
// locally on this ESP32. No Wi-Fi passwords are transported over the cloud.
void pollSavedNetworkSwitch() {
  if (!wifiPortal.connected() || nemaBusy || homing || pendingCommandId.length()) return;
  JsonDocument request, response;
  request["action"] = "claim_switch";
  request["device_code"] = DEVICE_CODE;
  WiFiClientSecure client;
  // Legacy sketch currently uses setInsecure for motor/status. Harden with a
  // verified CA certificate before using on untrusted networks.
  client.setInsecure();
  HTTPClient http;
  if(!http.begin(client,WIFI_STATUS_URL)) return;
  http.setTimeout(6500);
  http.addHeader("Content-Type","application/json");
  http.addHeader("x-device-secret",DEVICE_SECRET);
  String payload; serializeJson(request,payload);
  int code=http.POST(payload);
  String body = code==200 ? http.getString() : "";
  http.end();
  if(code!=200) { Serial.printf("[WiFi switch] HTTP %d\n",code);return; }
  if(deserializeJson(response,body) || !(response["switch"] | false)) return;
  String target=response["ssid"].as<String>();
  if(target==WiFi.SSID()) return;
  if (!wifiPortal.remoteSwitch(target))
    Serial.printf("[WiFi switch] Rejected unknown/pending SSID: %s\n",target.c_str());
}
void updateWeightStream();

// =====================================================
// MOTOR COMMAND VALIDATION AND SOFTWARE STOP
// =====================================================
bool validSteps(int steps) {
  // Preserve existing Supabase command values. These represent NEMA STEP pulses now.
  return steps == 50 || steps == 100 || steps == 267 || steps == 533;
}

void emergencyStop() {
  if (pendingCommandId.length()) pendingFailure = true;
  stopNema();
  homing = false;
  homed = false; // Position no longer trustworthy after interruption.
  compartmentIndex = -1;
  Serial.println("[NEMA17] STOPPED; HOME again before feeding (software stop only)");
}

// =====================================================
// REPORT COMMAND COMPLETION
// =====================================================
void acknowledgeCommand(
  const String& commandId,
  bool completed
) {
  for (int attempt = 0; attempt < 3; ++attempt) {
    JsonDocument request;
    JsonDocument response;
    request["action"] = "complete";
    request["device_code"] = DEVICE_CODE;
    request["command_id"] = commandId;
    request["result"] = completed ? "completed" : "failed";
    if (sendRequest(request, response)) {
      Serial.println("Command completion acknowledged.");
      return;
    }
    delay(500);
  }
  Serial.println(
    "Completion could not be reported. "
    "Check the command row in Supabase."
  );
  Serial.println("Do not repeat the motor movement.");
}
// =====================================================
// CLAIM ONE DASHBOARD COMMAND
// =====================================================
void pollMotorCommand() {
  // Allow polling even when unhomed: a dashboard HOME command must be able to recover it.
  if (!remoteEnabled || nemaBusy || pendingCommandId.length()) return;
  JsonDocument request;
  JsonDocument response;
  request["action"] = "claim";
  request["device_code"] = DEVICE_CODE;
  if (!sendRequest(request, response)) return;
  if (!(response["rotate"] | false)) return;
  String commandId = response["command_id"].as<String>();
  // Fail closed: never interpret a missing command_type as a rotation.
  String commandType = response["command_type"].is<const char*>()
    ? response["command_type"].as<String>() : "";
  int steps = response["steps"] | 0;
  String direction = response["direction"].as<String>();
  Serial.printf("[CLOUD CLAIM] id=%s type='%s' steps=%d direction='%s'\n",
                commandId.c_str(), commandType.c_str(), steps, direction.c_str());
  if (commandType.length() == 0) {
    Serial.println("[CLOUD CLAIM] ERROR: command_type missing; motor BLOCKED.");
    if (commandId.length() == 36) acknowledgeCommand(commandId, false);
    return;
  }
  if (commandId.length() != 36) {
    Serial.println("Invalid command ID; movement blocked.");
    return;
  }
  if ((commandType != "home" && commandType != "rotate") ||
      !validSteps(steps) ||
      (direction != "clockwise" && direction != "counterclockwise")) {
    Serial.println("Invalid motor command; movement blocked.");
    acknowledgeCommand(commandId, false);
    return;
  }
  if (commandId == lastCommandId) {
    Serial.println(
      "Previously processed command blocked. "
      "Check its status in Supabase."
    );
    return;
  }
  // Save before movement to prevent replay after restart.
  if (!storageReady ||
      preferences.putString("last_cmd", commandId)
        != commandId.length()) {
    Serial.println("Could not save command ID; movement blocked.");
    acknowledgeCommand(commandId, false);
    return;
  }
  lastCommandId = commandId;
  Serial.print("\nDashboard command received: ");
  Serial.println(commandId);
  // The claimed command is saved before movement, preventing replay after restart.
  // For HOME, the steps/direction fields are compatibility placeholders only.
  // The real homing routine uses GPIO27 + debounce + 450-ms extra travel.
  bool accepted = commandType == "home"
    ? startHome()
    : startNema(steps, direction == "clockwise");
  if (accepted) {
    pendingCommandId = commandId;
    Serial.printf("[DASHBOARD] %s command accepted\n", commandType.c_str());
  } else acknowledgeCommand(commandId, false);
}
// =====================================================
// PHYSICAL BUTTON — interrupt latches presses even during HTTP requests
// =====================================================

void checkButton() {
  if (buttonDiagnostic && millis()-lastButtonDiagnosticAt >= 250) {
    lastButtonDiagnosticAt=millis();
    Serial.printf("[GPIO32] level=%s, interrupt count=%lu (release=HIGH, press=LOW)\n",
      digitalRead(BUTTON_PIN)==LOW ? "LOW/PRESSED" : "HIGH/RELEASED",
      (unsigned long)buttonPressCount);
  }
  uint32_t presses;
  noInterrupts(); presses=buttonPressCount; interrupts();
  if (suppressButtonUntilReleased) {
    if (digitalRead(BUTTON_PIN)==HIGH) suppressButtonUntilReleased=false;
    handledButtonCount=presses;
    return;
  }
  if (presses==handledButtonCount) return;
  handledButtonCount=presses;
  unsigned long now=millis();
  if (now-lastButtonActionAt < BUTTON_LOCKOUT_MS) return;
  if (nemaBusy || homing || pendingCommandId.length() || !homed) {
    Serial.println("[GPIO32] Not ready. Home with G first, or motor busy.");
    return;
  }
  lastButtonActionAt=now;
  Serial.println("[GPIO32] BUTTON PRESSED -> NEMA17 CW");
  if (!startNema(NEMA_STEPS_120, true)) Serial.println("[GPIO32] Could not start NEMA17.");
}

// =====================================================
// HX711 — continuous, nonblocking 150 ms display + EMA smoothing
// =====================================================

// Reads and reports RAW ADC counts. This is NOT grams until calibrated.
// Reject constant full-scale samples instead of pretending they are weight.
void printWeight() {
  if (!scale.is_ready()) {
    if (millis() - lastWeightWarningAt >= 2000) {
      lastWeightWarningAt = millis();
      Serial.println("[HX711] NOT READY - check DT=GPIO16, SCK=GPIO13, VCC, GND.");
    }
    return;
  }

  long raw = scale.read();
  hxLastRaw = raw;
  const bool saturated = (raw == 8388607L || raw == -8388608L);
  if (saturated) {
    hxHasValidSample = false;
    foodTelemetrySampleReady = false;
    hxFilterInitialized = false;
    Serial.printf("[HX711] RAW: %ld | SATURATED - check E+/E-/A+/A- and load range\n", raw);
    return;
  }

  if (raw == 0) {
    // Zero can be a legitimate single ADC reading, but persistent exact zero is suspicious.
    Serial.println("[HX711] WARNING: RAW=0 (if persistent, inspect DOUT and wiring)");
  }

  hxHasValidSample = true;
  if (!hxFilterInitialized) {
    hxFiltered = static_cast<float>(raw);
    hxFilterInitialized = true;
  } else {
    hxFiltered = 0.20f * static_cast<float>(raw) + 0.80f * hxFiltered;
  }

  Serial.printf("[HX711] RAW: %ld | FILTERED: %.1f", raw, hxFiltered);
  if (hxBaselineSet) {
    float grams = (hxFiltered - static_cast<float>(hxBaseline)) /
                  HX711_CALIBRATION_FACTOR;
    // Detection always uses unsuppressed values; only display clamps near zero.
    float displayedG = (grams > -2.0f && grams < 2.0f) ? 0.0f : grams;
    Serial.printf(" | WEIGHT: %.2f g", displayedG);
    Serial.println();
    updateFoodDetection(grams);
    // Send filtered, tared grams only (never an uncalibrated raw ADC reading).
    if (isfinite(grams) && grams >= -100.0f && grams <= 10000.0f) {
      latestFoodWeightG = grams;
      lastValidFoodSampleAt = millis();
      foodTelemetrySampleReady = true;
    } else {
      foodTelemetrySampleReady = false;
    }
    return;
  } else {
    Serial.print(" | NOT TARED - press Z with empty plate installed");
  }
  Serial.println();
}

void updateWeightStream() {
  if (!weightStreaming) return;
  if (millis() - lastWeightAt < WEIGHT_INTERVAL_MS) return;
  lastWeightAt = millis();
  printWeight();
}

// Device-authenticated, periodic HTTP upload to the new food telemetry function.
// This runs ONLY from loop() after the motor has stopped and settled.
void reportFoodTelemetry() {
  const unsigned long nowMs = millis();
  if (nowMs - lastFoodTelemetryAt < FOOD_TELEMETRY_INTERVAL_MS) return;
  if (!wifiPortal.connected() || nemaBusy || homing || pendingCommandId.length()) return;
  if (nowMs - motorLastStoppedMs < MOTOR_SETTLE_MS) return;
  if (!hxBaselineSet || !hxHasValidSample || !foodTelemetrySampleReady) return;
  if (nowMs - lastValidFoodSampleAt > FOOD_SAMPLE_MAX_AGE_MS) return;
  if (!isfinite(latestFoodWeightG)) return;

  // Mark before sending so failures cannot cause a rapid retry loop.
  lastFoodTelemetryAt = nowMs;
  JsonDocument payload;
  payload["device_code"] = DEVICE_CODE;
  payload["weight_estimate_g"] = max(0.0f, latestFoodWeightG);
  String body;
  serializeJson(payload, body);

  WiFiClientSecure client;
  // Matches the existing firmware's TEMPORARY TLS mode. For a deployed device,
  // replace with certificate validation (trusted CA/root certificate).
  client.setInsecure();
  client.setHandshakeTimeout(5);
  HTTPClient http;
  if (!http.begin(client, FOOD_TELEMETRY_URL)) {
    Serial.println("[FOOD CLOUD] HTTPS initialization failed");
    return;
  }
  http.setTimeout(3500);
  http.addHeader("Content-Type", "application/json");
  http.addHeader("x-device-secret", DEVICE_SECRET);
  const int code = http.POST(body);
  const String reply = code > 0 ? http.getString() : "";
  http.end();

  if (code == 200) {
    Serial.printf("[FOOD CLOUD] Sent %.1f g -> HTTP 200\n", latestFoodWeightG);
    // The Edge Function, not the ESP32, creates possible-eating event rows.
  } else if (nowMs - lastFoodTelemetryErrorAt >= 10000) {
    lastFoodTelemetryErrorAt = nowMs;
    Serial.printf("[FOOD CLOUD] Upload failed (HTTP %d)\n", code);
    if (reply.length()) Serial.println(reply);
  }
}

void tareLoadCell() {
  Serial.println("[HX711] Remove weight and keep sensor still; averaging 10 readings...");
  if (!scale.wait_ready_timeout(1500)) {
    Serial.println("[HX711] Tare aborted - module not ready.");
    return;
  }
  // This waits for ADC conversions; run with motors idle.
  long value = scale.read_average(10);
  if (value == 8388607L || value == -8388608L) {
    Serial.println("[HX711] Tare aborted - ADC saturated.");
    return;
  }
  if (!storageReady) {
    Serial.println("[HX711] Tare aborted - ESP32 preferences storage unavailable; cannot save baseline.");
    return;
  }
  // Save first. Never announce a persistent tare unless the write succeeds.
  // ESP32 Preferences putLong() stores one signed 32-bit ADC zero reading.
  const size_t written = preferences.putLong(HX711_TARE_NVS_KEY, value);
  if (written != sizeof(int32_t)) {
    Serial.println("[HX711] Tare aborted - could not save zero baseline to flash.");
    return;
  }
  foodTelemetrySampleReady = false; // The previous measurement used the old tare.
  hxBaseline = value;
  hxBaselineSet = true;
  hxFilterInitialized = false;
  resetFoodDetection();
  Serial.println("[FOOD] EMPTY PLATE REFERENCE SAVED - will be restored after ESP32 restarts");
  Serial.println("[FOOD] Add food to start monitoring");
  Serial.printf("[HX711] Zero baseline: %ld raw units (not grams)\n", hxBaseline);
}

// =====================================================
// SERIAL MONITOR COMMANDS
// =====================================================
void checkSerialCommands() {
  while (Serial.available()) {
    char command = Serial.read();
    switch (command) {
      case 'T': case 't': testConnection(); break;
      case 'A': case 'a':
        if (!storageReady) {
          Serial.println("Cannot enable remote: storage unavailable.");
          break;
        }
        if (!endpointReady && !testConnection()) {
          Serial.println("Cannot enable remote: Supabase unavailable.");
          break;
        }
        remoteEnabled = true;
        lastPoll = millis() - POLL_INTERVAL_MS;
        Serial.println("Remote dashboard control ENABLED.");
        break;
      case 'D': case 'd':
        remoteEnabled = false;
        Serial.println("Remote dashboard control DISABLED.");
        break;
      case 'G': case 'g': Serial.println(startHome()?"[HOME] Started":"[HOME] Busy"); break;
      case 'P': case 'p': Serial.printf("[HOME] sensor=%s, homed=%s, compartment=%d\n", homePressed()?"PRESSED":"RELEASED", homed?"YES":"NO", compartmentIndex); break;
      case 'F': case 'f': Serial.println(startNema(533,true)?"[NEMA] CW queued":"[NEMA] Busy"); break;
      case 'R': case 'r': Serial.println(startNema(533,false)?"[NEMA] CCW queued":"[NEMA] Busy"); break;
      case 'W': case 'w':
        weightStreaming = true;
        Serial.println("[HX711] Continuous readings ON (S to stop).");
        break;
      case 'S': case 's':
        weightStreaming = false;
        Serial.println("[HX711] Continuous readings OFF.");
        break;
      case 'Z': case 'z':
        if (nemaBusy) Serial.println("[HX711] Stop motors before taring.");
        else tareLoadCell();
        break;
      case 'B': case 'b':
        buttonDiagnostic=!buttonDiagnostic;
        Serial.printf("[Button] GPIO32=%d, IRQ count=%lu, live diagnostic=%s\n",
           digitalRead(BUTTON_PIN),(unsigned long)buttonPressCount,buttonDiagnostic?"ON":"OFF");
        break;
      case 'H': case 'h': printWeight(); break;
      case 'C': case 'c':
        // Explicitly forget the old tare both in RAM and in ESP32 flash.
        if (!storageReady || !preferences.remove(HX711_TARE_NVS_KEY)) {
          Serial.println("[HX711] Could not clear saved tare; verify storage / whether a tare exists.");
          break;
        }
        foodTelemetrySampleReady = false;
        hxBaselineSet = false;
        hxHasValidSample = false;
        hxFilterInitialized = false;
        resetFoodDetection();
        Serial.println("[HX711] Saved baseline erased; empty the plate and press Z to tare again.");
        break;
      case 'K': case 'k': testRtcScheduleDryRun(); break;
      case 'J': case 'j':
        if(!rtcPresent)Serial.println("[RTC] NOT DETECTED");
        else {DateTime n=rtc.now();Serial.printf("[RTC] %04d-%02d-%02d %02d:%02d:%02d | valid=%d | enabled=%d | physical=%d | config v%lu\n",n.year(),n.month(),n.day(),n.hour(),n.minute(),n.second(),rtcClockValid,rtcEnabled,RTC_ALLOW_MOTOR_DISPENSING,(unsigned long)rtcConfigVersion);}
        break;
      case 'X': case 'x': emergencyStop(); rtcMoveSegmentsLeft=0;rtcActiveMeal=-1; break;
      case '\n': case '\r': case ' ': break;
      default: Serial.printf("Unknown command: %c\n", command); break;
    }
  }
}

// =====================================================
// SETUP
// =====================================================
void setup() {
  Serial.begin(115200);
  delay(1000);
  pinMode(NEMA_STEP_PIN, OUTPUT);
  pinMode(NEMA_DIR_PIN, OUTPUT);
  digitalWrite(NEMA_STEP_PIN, LOW);
  digitalWrite(NEMA_DIR_PIN, HIGH);
  pinMode(BUTTON_PIN, INPUT_PULLUP);
  pinMode(LIMIT_SWITCH_PIN, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(BUTTON_PIN), onButtonFalling, FALLING);
  scale.begin(HX711_DT, HX711_SCK);
  motorLastStoppedMs = millis();
  lastButtonActionAt = millis() - BUTTON_LOCKOUT_MS;
  lastButtonIRQus = micros() - 60000UL;
  storageReady = preferences.begin("carefur", false);
  if (storageReady) {
    lastCommandId = preferences.getString("last_cmd", "");
    if (preferences.isKey(HX711_TARE_NVS_KEY)) {
      hxBaseline = preferences.getLong(HX711_TARE_NVS_KEY, 0);
      // A saved zero is a raw HX711 ADC value, which may legitimately be zero.
      hxBaselineSet = true;
      hxFilterInitialized = false;
      hxHasValidSample = false;
      foodTelemetrySampleReady = false;
      resetFoodDetection();
      Serial.printf("[HX711] Restored saved empty-plate baseline: %ld raw units\n", hxBaseline);
      Serial.println("[HX711] Tare not required on restart. Press Z only with an empty plate to recalibrate.");
    } else {
      Serial.println("[HX711] No saved tare. Empty the plate and press Z once to save the reference.");
    }
  } else {
    Serial.println("[HX711] Preferences unavailable: cannot load or save tare; check storage.");
  }
  Serial.println("\n========================");
  Serial.println("CAREFUR ESP32 MOTOR TEST");
  Serial.println("NEMA17 STEP=33 DIR=26 | BUTTON=32 | HOME=27");
  Serial.println("TLS certificate checking DISABLED");
  Serial.println("AUTO DASHBOARD CONTROL ENABLED");
  Serial.println("OFFLINE WIFI SETUP ENABLED");
  Serial.println("========================");
  // Initialize local provisioning once. If not online, creates a nearby setup hotspot.
  wifiPortal.enableCameraPairing(CAMERA_PAIR_KEY);
  wifiPortal.begin();
  loadRtcConfig();
  setupRtc();
  Serial.printf("[RTC] Cached config v%lu, enabled=%d, physical motor enabled=%d\n", (unsigned long)rtcConfigVersion,rtcEnabled,RTC_ALLOW_MOTOR_DISPENSING);
  // Avoid blocking setup with automatic HTTPS request; use Serial T to test.
  // Start polling immediately after boot.
  // Remain enabled even if offline on boot; automatically resumes polling
  // when provisioning succeeds and Internet/Supabase becomes available.
  remoteEnabled = storageReady;
  Serial.println("[HOME] Feeding locked until homed. AUTO startup homing enabled.");
  if (AUTO_HOME_ON_BOOT) startHome();
  lastPoll = millis() - POLL_INTERVAL_MS;
  if (remoteEnabled) {
    Serial.println("\nRemote dashboard control is ACTIVE.");
    Serial.println("Click Rotate 120 degrees in CareFur Admin.");
  } else {
    Serial.println("\nRemote dashboard control could not start automatically.");
    Serial.println("Fix the connection/storage issue, then press A to enable it.");
  }
  Serial.println("\nSerial Monitor commands:");
  Serial.println("T = Test Supabase connection");
  Serial.println("A = Enable automatic dashboard control");
  Serial.println("D = Disable automatic dashboard control");
  Serial.println("G = Home using GPIO27 switch; P = Show switch and position");
  Serial.println("F/R = NEMA17 clockwise/counterclockwise (533 pulses) after home");
  Serial.println("BUTTON GPIO32 -> NEMA17 clockwise");
  Serial.println("Dashboard command -> NEMA17");
  Serial.println("NOTE: NEMA17 pauses HX711 streaming while rotating.");
  Serial.println("X = STOP motor immediately");
  Serial.println("W = Start continuous HX711 readings (also auto-start on boot)");
  Serial.println("S = Stop continuous HX711 readings");
  Serial.println("Z = Calibrate EMPTY plate and SAVE tare to ESP32 flash (persists across restart)");
  Serial.println("C = Clear saved tare from ESP32 flash; press Z on empty plate to restore");
  Serial.println("[FOOD] Detection uses sustained ~5g-equivalent load reductions (not proof of eating)");
  Serial.println("[FOOD CLOUD] Tare with Z; filtered load uploads every 3 s when idle/online.");
  Serial.println("H = One diagnostic HX711 raw reading | C = reset raw baseline");
  Serial.println("B = Toggle LIVE GPIO32 diagnostic (250ms)");
  Serial.println("Shared setup: join CareFur-Feeder-Setup, then http://192.168.4.1/");
  Serial.println("RTC DS3231: SDA=21 SCL=22; cached meal times sync when online; Serial J = status, K = safe schedule test");
}
// =====================================================
// LOOP
// =====================================================
void loop() {
  // Prioritize reliable STEP pulses; avoid blocking network activity while moving.
  tickNema();
  checkButton();
  checkSerialCommands();
  tickNema();

  if (pendingFailure && pendingCommandId.length()) {
    pendingFailure = false;
    String id = pendingCommandId;
    pendingCommandId = "";
    acknowledgeCommand(id, false);
  }
  if (nemaFinished) {
    nemaFinished = false;
    // Only 533-pulse indexing moves are counted as compartment changes.
    // Other pulse counts invalidate position until rehomed.
    // This update is done in startNema completion tracking below.
    if (pendingCommandId.length()) {
      String id = pendingCommandId;
      pendingCommandId = "";
      acknowledgeCommand(id, true);
    } else if (rtcMoveSegmentsLeft > 0) {
      finishRtcMotorSegment();
    }
  }

  if (nemaBusy) return;
  if (pendingCommandId.length()) return;

  updateWeightStream();
  wifiPortal.loop();
  syncRtcClockFromNtp();
  checkRtcFeeding();
  if(nemaBusy || rtcMoveSegmentsLeft>0)return;
  if(wifiPortal.connected() && (!rtcSyncAttempted || millis()-lastRtcSync>=RTC_SYNC_INTERVAL_MS)) {
    rtcSyncAttempted=true;
    lastRtcSync=millis();
    syncRtcSchedule();
  }
  // No POST during stepping; allow 3 s for vibrations to settle afterward.
  reportFoodTelemetry();
  if (wifiPortal.connected() && (!wifiReportOnce || millis()-lastWiFiReport >= WIFI_REPORT_INTERVAL_MS)) {
    wifiReportOnce = true;
    lastWiFiReport = millis();
    reportWiFiStatus();
  }
  if (!wifiPortal.connected()) wifiReportOnce = false;
  if (wifiPortal.connected() && millis()-lastWiFiSwitchPoll >= WIFI_SWITCH_POLL_MS) {
    lastWiFiSwitchPoll = millis();
    pollSavedNetworkSwitch();
  }
  checkButton();
  if (remoteEnabled && wifiPortal.connected() && !nemaBusy &&
      millis()-lastPoll >= POLL_INTERVAL_MS) {
    lastPoll = millis();
    pollMotorCommand();
  }
  tickNema();
  delay(1);
}