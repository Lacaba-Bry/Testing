import "./Common.css";

export default function PageHeader({ title, description, actions }) {
  return (
    <header className="ui-page-header">
      <div>
        
        <h1>{title}</h1>
        {description && <p className="ui-page-description">{description.split(".")[0]}.</p>}
      </div>
      {actions && <div className="ui-page-actions">{actions}</div>}
    </header>
  );
}
