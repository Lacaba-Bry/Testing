import "./Common.css";
export default function StatusDot({status="neutral",label}) {return <span className={`cf-status-dot cf-status-${status}`} role={label?"img":undefined} aria-label={label} aria-hidden={label?undefined:true}/>}
