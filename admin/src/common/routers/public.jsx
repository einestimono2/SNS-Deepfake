import { lazyImport } from '#/common/utils';

const { AuthRoutes } = lazyImport(() => import('#/features/auth'), 'AuthRoutes');

export const publicRoutes = [
  {
    path: '/*',
    element: <AuthRoutes />,
  },
];
