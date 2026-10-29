import { BookOpenText, Camera, Robot, WifiHigh, WarningCircle } from "@phosphor-icons/react";
import { Link } from "react-router-dom";
import PageHeader from "../components/common/PageHeader";
import "./ConnectionManual.css";

export default function ConnectionManual() {
  return (
    <section className="connection-guide">
      <PageHeader title="Connection Manual" description="Staff guide for reconnecting CareFur feeder and camera devices." />
      <div className="guide-intro"><BookOpenText size={24}/><p>Wi-Fi provisioning requires someone near the equipment. The online dashboard cannot reconnect a device that is powered off or has no network access.</p></div>
      <div className="guide-grid">
        <article className="guide-card"><header><Robot size={24}/><h2>ESP32 feeder</h2></header>
          <ol><li>Check that the feeder and power supply are switched on.</li><li>Restart the feeder and wait for it to reconnect automatically.</li><li>If the saved Wi-Fi is unavailable, use a phone to connect to <strong>CareFur-Feeder-Setup</strong>, when its installed firmware exposes that hotspot.</li><li>Open <strong>http://192.168.4.1</strong> on that phone and save your 2.4 GHz network credentials.</li><li>Wait for the feeder to reconnect and verify the online state in the Feeder Wi-Fi manager.</li></ol>
          <Link to="/feeder-wifi-manager">Open Feeder Wi-Fi manager →</Link></article>
        <article className="guide-card"><header><Camera size={24}/><h2>ESP32 camera</h2></header>
          <ol><li>Check camera power, USB cable, and router availability.</li><li>Restart the camera and wait for its last saved network.</li><li>If it fails, connect a phone to <strong>CareFur-Camera-Setup</strong>, when supported by the current firmware.</li><li>Open <strong>http://192.168.9.1:8080</strong> locally to configure Wi-Fi.</li><li>Confirm the camera Wi-Fi status and then test the camera gateway, whose camera IP may need updating.</li></ol>
          <Link to="/hardware-setup">Open Camera Wi-Fi connection →</Link></article>
      </div>
      <div className="guide-alert"><WarningCircle size={21}/><p><strong>Security:</strong> Never share router passwords in chat or screenshots. Device setup hotspot names and portal URLs depend on the installed ESP32 firmware.</p></div>
      <p className="guide-footer"><WifiHigh size={18}/> Most ESP32 boards require a 2.4 GHz Wi-Fi network.</p>
    </section>
  );
}
