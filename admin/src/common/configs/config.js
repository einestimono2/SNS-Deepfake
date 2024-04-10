export const API_URL = import.meta.env.VITE_MY_ENV
  ? import.meta.env.VITE_API_DEV_URL
  : import.meta.env.VITE_API_PROD_URL;
