import {
  BellRinging,
  CalendarCheck,
  CalendarPlus,
  Camera,
  ChatCircleDots,
  Circuitry,
  ForkKnife,
  GearSix,
  House,
  PawPrint,
  SignOut,
  SquaresFour,
  UsersThree,
  WifiHigh,
  CaretDown,
  BookOpenText,
  ChatsCircle,
} from "@phosphor-icons/react";
import { NavLink, useLocation, Link } from "react-router-dom";
import { useState } from "react";
import logo from "../../assets/logos/snuggles_logo.png";
import useAuth from "../../hooks/useAuth";
import "./Sidebar.css";

const CAREFUR_NAME = "CareFur";
const groups = [
  {
    title: "Overview",
    items: [
      { label: "Dashboard", to: "/dashboard", icon: SquaresFour },
      { label: "Alerts", to: "/alerts", icon: BellRinging },
      { label: "Messages", to: "/messages", icon: ChatCircleDots },
      { label: "Client Inquiries", to: "/inquiries", icon: ChatsCircle },
    ],
  },
  {
    title: "Stays",
    items: [
      { label: "Boarding List", to: "/boardings", icon: CalendarCheck },
      { label: "Rooms", to: "/rooms", icon: House },
      { label: "Pets", to: "/pets", icon: PawPrint },
    ],
  },
  {
    title: "Care",
    items: [
      { label: "Feeding", to: "/feeding-schedules", icon: ForkKnife },
      { label: "Cameras", to: "/cameras", icon: Camera },
    ],
  },
  {
    title: "Admin",
    items: [{ label: "Staff", to: "/staff", icon: UsersThree, adminOnly: true }],
  },
];

const hardwareItems = [
  { label: "Connection Manual", to: "/connection-manual", icon: BookOpenText },
  { label: "Camera Wi-Fi", to: "/hardware-setup", icon: WifiHigh },
  { label: "Feeder ESP32", to: "/motor-test", icon: GearSix },
  { label: "Feeder Wi-Fi", to: "/feeder-wifi-manager", icon: WifiHigh },
  { label: "Camera Test", to: "/camera-test", icon: Camera },
];

export default function Sidebar({ isOpen, onClose }) {
  const location = useLocation();
  const hardwareIsActive = hardwareItems.some((item) => item.to === location.pathname);
  const [expanded, setExpanded] = useState(hardwareIsActive);
  const { logout, profile, isAdmin } = useAuth();

  return (
    <aside className={`sidebar ${isOpen ? "sidebar-open" : ""}`}>
      <div className="sidebar-brand">
        <img src={logo} alt="CareFur" className="sidebar-brand__logo" />
        <div className="sidebar-brand__copy">
          <strong>{CAREFUR_NAME}</strong>
          <span>Pet Hotel Console</span>
        </div>
        <button className="sidebar-close" type="button" aria-label="Close navigation" onClick={onClose}>
          ×
        </button>
      </div>

      <Link className="cf-new-boarding" to="/boarding/new" onClick={onClose}>
        <CalendarPlus size={17} />
        <span>New Boarding</span>
      </Link>

      <nav className="sidebar-nav" aria-label="Main navigation">
        {groups.map((group) => (
          <div key={group.title} className="sidebar-group">
            <p className="sidebar-group-title">{group.title}</p>
            {group.items
              .filter((item) => !item.adminOnly || isAdmin)
              .map((item) => {
                const Icon = item.icon;
                return (
                  <NavLink
                    key={item.to}
                    to={item.to}
                    onClick={onClose}
                    className={({ isActive }) => `sidebar-link ${isActive ? "sidebar-link-active" : ""}`}
                  >
                    <Icon size={18} weight="regular" />
                    <span>{item.label}</span>
                  </NavLink>
                );
              })}

            {group.title === "Admin" && isAdmin && (
              <div className="sidebar-hardware-group">
                <button
                  type="button"
                  className={`sidebar-link sidebar-hardware-toggle ${hardwareIsActive ? "sidebar-hardware-active" : ""}`}
                  onClick={() => setExpanded((value) => !value)}
                  aria-expanded={expanded}
                >
                  <Circuitry size={18} />
                  <span>Hardware</span>
                  <CaretDown size={14} className={`sidebar-hardware-caret ${expanded ? "sidebar-hardware-caret-open" : ""}`} />
                </button>

                {expanded && (
                  <div className="sidebar-hardware-links">
                    {hardwareItems.map((item) => {
                      const Icon = item.icon;
                      return (
                        <NavLink
                          key={item.to}
                          to={item.to}
                          onClick={onClose}
                          className={({ isActive }) => `sidebar-link sidebar-hardware-child ${isActive ? "sidebar-link-active" : ""}`}
                        >
                          <Icon size={16} />
                          <span>{item.label}</span>
                        </NavLink>
                      );
                    })}
                  </div>
                )}
              </div>
            )}
          </div>
        ))}
      </nav>

      <div className="sidebar-account">
        <div className="sidebar-avatar">
          {(profile?.full_name || "CF")
            .split(" ")
            .slice(0, 2)
            .map((part) => part[0])
            .join("")}
        </div>
        <div className="sidebar-account__copy">
          <strong>{profile?.full_name || "CareFur Staff"}</strong>
          <span>{profile?.role || "staff"}</span>
        </div>
        <button
          type="button"
          className="sidebar-logout"
          onClick={() => logout().catch(console.error)}
          aria-label="Log out"
        >
          <SignOut size={18} />
        </button>
      </div>
    </aside>
  );
}
