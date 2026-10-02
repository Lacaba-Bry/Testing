import {useCallback,useEffect,useState} from "react";
import {Link} from "react-router-dom";
import {ArrowClockwise,ArrowSquareOut,Camera,WifiHigh,WifiSlash,Info} from "@phosphor-icons/react";
import PageHeader from "../components/common/PageHeader";
import {supabase} from "../services/supabaseClient";
import {CAMERA_GATEWAY_URL,checkCameraGateway} from "../services/cameraGateway";
import "./HardwareSetup.css";
import "./FeederWiFiManager.css";

const PORTAL="http://192.168.9.1:8080/";
function age(iso){if(!iso)return "Never";const n=Math.max(0,Math.round((Date.now()-Date.parse(iso))/1000));return Number.isFinite(n)?`${n}s ago`:"Unknown";}
export default function HardwareSetup(){
  const [data,setData]=useState(null),[onlineFromServer,setOnline]=useState(false);
  const [loading,setLoading]=useState(true),[error,setError]=useState("");
  const [clock,setClock]=useState(Date.now()),[switchInfo,setSwitchInfo]=useState(null);
  const [switchBusy,setSwitchBusy]=useState(""),[notice,setNotice]=useState("");
  const [testing,setTesting]=useState(false),[test,setTest]=useState(null);
  const refresh=useCallback(async()=>{
    try{
      const {data:result,error:err}=await supabase.functions.invoke("camera-wifi-status",{body:{action:"read"}});
      if(err)throw err;
      if(!result?.ok)throw Error(result?.error||"Could not read camera status");
      setData(result.status);setOnline(!!result.online);setSwitchInfo(result.switch_request);setError("");
    }catch(e){setError(e.message||"Status unavailable");}
    finally{setLoading(false);}
  },[]);
  useEffect(()=>{refresh();const timer=setInterval(refresh,3000);const tick=setInterval(()=>setClock(Date.now()),1000);return()=>{clearInterval(timer);clearInterval(tick);};},[refresh]);
  const fresh=data?.last_seen&&clock-Date.parse(data.last_seen)<20000;
  const online=!!(onlineFromServer&&fresh&&data?.connected&&!error);
  async function selectNetwork(ssid){
    if(!window.confirm(`Switch camera to saved Wi-Fi “${ssid}”? Video may temporarily disconnect. The camera and gateway must stay on reachable networks.`))return;
    setNotice("");setSwitchBusy(ssid);
    try{
      const {data:result,error:err}=await supabase.functions.invoke("camera-wifi-status",{body:{action:"queue_switch",ssid}});
      if(err)throw err;if(!result?.ok)throw Error(result?.error||"Switch rejected");
      setNotice(`Requested ${ssid}. Wait for a new heartbeat confirming the connected SSID.`);
      await refresh();
    }catch(e){setNotice(`Switch failed: ${e.message||"Unknown error"}`);}
    finally{setSwitchBusy("");}
  }
  async function testCamera(){setTesting(true);setTest(null);const controller=new AbortController();const timeout=setTimeout(()=>controller.abort(),10000);
    try{const result=await checkCameraGateway(CAMERA_GATEWAY_URL,controller.signal);setTest({ok:true,message:`Gateway can reach camera (${result.camera_host||"online"}).`});}
    catch(e){setTest({ok:false,message:e.name==="AbortError"?"Gateway timed out":e.message});}
    finally{clearTimeout(timeout);setTesting(false);}
  }
  const networks=Array.isArray(data?.saved_networks)?data.saved_networks:[];
  return <section className="hardware-setup feeder-wifi-page">
    <PageHeader eyebrow="Hardware Monitoring" title="Camera Wi-Fi Setup" description="Automatic ESP32-CAM Wi-Fi status and remote switching between saved networks."/>
    <div className="hardware-note"><Info size={24}/><div><strong>Automatic cloud monitoring</strong><p>ESP32-CAM reports approximately every 5 seconds. This page checks every 3 seconds and marks the camera offline after 20 seconds without a heartbeat. The video gateway is tested separately.</p></div></div>
    <div className="hardware-panel"><div className="hardware-section-heading"><Camera size={24}/><h2>Camera Wi-Fi connection</h2></div>
      <div className="hardware-info-grid">
        <div><span>Status</span><strong className={online?"fw-online":"fw-offline"}>{loading?"Checking…":online?<><WifiHigh size={19}/> Online</>:<><WifiSlash size={19}/> Offline</>}</strong></div>
        <div><span>Current Wi-Fi</span><strong>{online?data.connected_ssid||"Unknown":"Not currently reporting"}</strong></div>
        <div><span>Preferred saved Wi-Fi</span><strong>{data?.saved_ssid||"Not yet reported"}</strong></div>
        <div><span>Last IP (camera LAN)</span><strong>{data?.ip_address||"Not yet reported"}</strong></div>
        <div><span>Signal strength</span><strong>{typeof data?.rssi==="number"?`${data.rssi} dBm`:"Unavailable"}</strong></div>
        <div><span>Last seen</span><strong>{age(data?.last_seen)}</strong></div>
      </div>
      {error&&<p role="alert" className="fw-error">{error}</p>}
      <div className="hardware-actions"><button className="hardware-secondary" onClick={refresh}><ArrowClockwise size={17}/> Refresh</button></div>
    </div>
    <div className="hardware-panel"><div className="hardware-section-heading"><WifiHigh size={24}/><h2>Saved camera Wi-Fi networks</h2></div>
      <p>Select a previously saved network while the camera is online. Router passwords stay on the ESP32.</p>
      <div className="fw-saved-list">{networks.length?networks.map(ssid=><div className="fw-saved-item" key={ssid}>
        <div className="fw-saved-icon"><WifiHigh size={23}/></div>
        <div className="fw-saved-name"><strong>{ssid}</strong><small>{online&&ssid===data.connected_ssid?"Currently connected":ssid===data.saved_ssid?"Preferred network":"Saved on camera"}</small></div>
        <button className="fw-switch-button" disabled={!online||!!switchBusy||ssid===data.connected_ssid} onClick={()=>selectNetwork(ssid)}>{switchBusy===ssid?"Sending…":online&&ssid===data.connected_ssid?"Connected":"Connect"}</button>
      </div>):<div className="fw-saved-empty">{loading?"Loading…":"No saved networks have been reported. Upload camera firmware and connect locally first."}</div>}</div>
      {notice&&<p role="status" className="fw-switch-message">{notice}</p>}
      {switchInfo?.state==="pending"&&<p className="hardware-subtle">Switch requested: {switchInfo.target_ssid}</p>}
      <p className="hardware-subtle">Switching may interrupt video. The Node.js camera gateway must be able to reach the camera's new local IP and network.</p>
    </div>
    <div className="hardware-panel"><h2>Shared setup with feeder</h2>
      <p>With shared-setup firmware installed on both devices, join <strong>CareFur-Feeder-Setup</strong> on your phone. Enter router Wi-Fi once at <strong>http://192.168.4.1</strong>. If this camera cannot reach its saved router, it automatically joins the feeder setup hotspot to securely collect the same network settings, then connects to the router independently.</p>
      <p>Keep both devices powered and nearby for first-time pairing. Existing camera-only recovery remains available at <strong>http://192.168.9.1:8080</strong> while connected to CareFur-Camera-Setup.</p>
      <div className="hardware-actions"><a className="hardware-primary hardware-link" href="http://192.168.4.1/" target="_blank" rel="noopener noreferrer">Open feeder shared setup <ArrowSquareOut size={17}/></a><Link className="hardware-secondary hardware-link" to="/feeder-wifi-manager">Feeder Wi-Fi Manager</Link></div>
    </div>
    <div className="hardware-panel"><h2>Add new Wi-Fi locally</h2><p>When the camera is offline or needs an unknown network, a nearby phone joins <strong>CareFur-Camera-Setup</strong> and opens the local setup portal. Your public dashboard cannot reach a device with no internet connection.</p>
      <div className="hardware-actions"><a className="hardware-primary hardware-link" href={PORTAL} target="_blank" rel="noopener noreferrer">Open local setup <ArrowSquareOut size={17}/></a><a className="hardware-secondary hardware-link" href="http://192.168.9.1:8080/scan" target="_blank" rel="noopener noreferrer">Scan locally <ArrowSquareOut size={17}/></a></div>
    </div>
    <div className="hardware-panel"><h2>Camera gateway test</h2><p className="hardware-endpoint">{CAMERA_GATEWAY_URL}/health</p>
      <div className="hardware-actions"><button className="hardware-primary" onClick={testCamera} disabled={testing}><ArrowClockwise size={18}/>{testing?"Testing…":"Test camera gateway"}</button><Link className="hardware-secondary hardware-link" to="/camera-test">Camera Test <ArrowSquareOut size={17}/></Link></div>
      {test&&<div role="status" className={`hardware-result ${test.ok?"success":"failure"}`}>{test.message}</div>}
    </div>
  </section>;
}
