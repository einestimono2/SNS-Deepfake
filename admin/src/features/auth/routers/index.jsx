import { Navigate, Route, Routes } from 'react-router-dom';

import { Login } from '../pages/Login';

export function AuthRoutes() {
  return (
    <Routes>
      <Route path="" element={<Login />} />
      <Route path="*" element={<Navigate to="." replace />} />
    </Routes>
  );
}
