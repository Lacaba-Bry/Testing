import "./Common.css";
export default function SummaryStrip({items}) {return <section className="cf-summary-strip" aria-label="Today in numbers">{items.map(item=><div key={item.label} className="cf-summary-stat"><strong>{item.value}</strong><span>{item.label}</span></div>)}</section>}
