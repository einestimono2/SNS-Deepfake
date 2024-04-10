import { Suspense } from 'react';
import { Outlet } from 'react-router-dom';

function App() {
  return (
    // <MainLayout>
    <Suspense
      fallback={<div className="h-full w-full flex items-center justify-center">{/* <Spinner size="xl" /> */}</div>}
    >
      <Outlet />
    </Suspense>
    // </MainLayout>
  );
}

export const protectedRoutes = [
  {
    path: '*',
    element: <App />,
    children: [
      // { path: '/discussions/*', element: <DiscussionsRoutes /> },
      // { path: '/users', element: <Users /> },
      // { path: '/profile', element: <Profile /> },
      // { path: '/', element: <Dashboard /> },
      // { path: '*', element: <Navigate to="." /> },
    ],
  },
];
