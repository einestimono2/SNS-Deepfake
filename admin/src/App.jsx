import { AppProvider } from '#/common/providers';
import { AppRoutes } from '#/common/routers';

export default function App() {
  return (
    <AppProvider>
      <AppRoutes />
    </AppProvider>
  );
}
