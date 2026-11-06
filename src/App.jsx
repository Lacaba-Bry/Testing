import { useState } from "react";
import { Navigate, Route, Routes } from "react-router-dom";

import ProtectedRoute from "./components/auth/ProtectedRoute";
import AdminRoute from "./components/auth/AdminRoute";
import DashboardLayout from "./components/layout/DashboardLayout";
import LoadingScreen from "./components/LoadingScreen";

import Login from "./pages/Login";
import Dashboard from "./pages/Dashboard";
import Activity from "./pages/Activity";
import NewBoarding from "./pages/NewBoarding";
import Boardings from "./pages/Boardings";
import Pets from "./pages/Pets";
import Rooms from "./pages/Rooms";
import FeedingSchedule from "./pages/FeedingSchedule";
import Cameras from "./pages/Cameras";
import Alerts from "./pages/Alerts";
import Messages from "./pages/Messages";
import StaffManagement from "./pages/StaffManagement";
import MotorTest from "./pages/MotorTest";
import CameraTest from "./pages/CameraTest";
import HardwareSetup from "./pages/HardwareSetup";
import FeederWiFiManager from "./pages/FeederWiFiManager";
import DeviceManual from "./pages/DeviceManual";

export default function App() {
  const [loading, setLoading] = useState(() => !sessionStorage.getItem("carefur-splash-seen") && !Object.keys(localStorage).some(key => key.startsWith("sb-") && key.endsWith("-auth-token")));

  if (loading) {
    return (
      <LoadingScreen
        onFinish={() => { sessionStorage.setItem("carefur-splash-seen", "1"); setLoading(false); }}
      />
    );
  }

  return (
    <Routes>
      <Route path="/login" element={<Login />} />

      <Route
        element={
          <ProtectedRoute allowedRoles={["admin", "staff"]}>
            <DashboardLayout />
          </ProtectedRoute>
        }
      >
        <Route index element={<Navigate to="/dashboard" replace />} />
        <Route path="/dashboard" element={<Dashboard />} />
        <Route path="/activity" element={<Activity />} />
        <Route path="/boarding/new" element={<NewBoarding />} />
        <Route path="/boardings" element={<Boardings />} />
        <Route path="/pets" element={<Pets />} />
        <Route path="/rooms" element={<Rooms />} />
        <Route path="/feeding-schedules" element={<FeedingSchedule />} />
        <Route path="/cameras" element={<Cameras />} />
        <Route path="/alerts" element={<Alerts />} />
        <Route path="/messages" element={<Messages />} />
        <Route path="/motor-test" element={<AdminRoute><MotorTest /></AdminRoute>} />
        <Route path="/feeder-wifi-manager" element={<AdminRoute><FeederWiFiManager /></AdminRoute>} />
        <Route path="/camera-test" element={<AdminRoute><CameraTest /></AdminRoute>} />
        <Route path="/device-manual" element={<AdminRoute><DeviceManual /></AdminRoute>} />
        <Route path="/hardware-setup" element={<AdminRoute><HardwareSetup /></AdminRoute>} />

        <Route
          path="/staff"
          element={
            <AdminRoute>
              <StaffManagement />
            </AdminRoute>
          }
        />
      </Route>

      <Route path="*" element={<Navigate to="/dashboard" replace />} />
    </Routes>
  );
}
