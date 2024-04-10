import { applicationDefault, initializeApp } from 'firebase-admin/app';

export const initializeFirebaseAdmin = () => {
  const app = initializeApp({
    credential: applicationDefault(),
    projectId: 'sns-deepfake'
  });

  return app;
};
