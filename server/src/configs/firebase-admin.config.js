import { applicationDefault, initializeApp } from 'firebase-admin/app';

export const initializeFirebaseAdmin = () => {
  const app = initializeApp({
    credential: applicationDefault(),
    projectId: 'deepfake-25d31'
  });

  return app;
};
