import { useEffect } from "react";
import "./LoadingScreen.css";
export default function LoadingScreen({onFinish}) {
  useEffect(()=>{const timer=setTimeout(()=>onFinish?.(),900);return ()=>clearTimeout(timer)},[onFinish]);
  return <div className="splash-screen" role="status"><div className="splash-logo-wrapper splash-logo-visible"><img src="/Logo.jpg" alt="CareFur" className="splash-logo" /></div><p className="splash-loading-text">Getting CareFur ready…</p></div>;
}
