export const API_URL = import.meta.env.REACT_APP_MY_ENV
  ? import.meta.env.REACT_APP_API_DEV_URL
  : import.meta.env.REACT_APP_API_PROD_URL;
