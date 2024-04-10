import axios from 'axios';
import { toast } from 'react-toastify';

import { API_URL } from '../../configs/config';
import { storage } from '../../utils';

const axiosClient = axios.create({
  baseURL: API_URL,
});

axiosClient.interceptors.request.use(async (config) => {
  const token = storage.getToken();
  const _config = config;

  if (token) {
    _config.headers.Authorization = `Bearer ${token}`;
  }

  return _config;
});

// const errorHandler = (error) => {
//   toast.error(error.message);
// };

axiosClient.interceptors.response.use(
  (response) => {
    if (response?.data) {
      return response.data;
    }

    return response;
  },

  async (error) => {
    // const originalRequest = error.config;

    const message = error.response?.data?.message || error.message;
    if (message) {
      toast.error(message);
      console.error('Unknown error:', error);
    }
    // else if (error.response.status === 401) {
    //   try {
    //     const refresh_token = localStorage.getItem('admin_refresh_token');
    //     const data = {
    //       refreshToken: refresh_token,
    //     };
    //     const response = await apiCaller({
    //       request: authApi.refreshToken(data),
    //       errorHandler,
    //     });
    //     console.log('Access token refreshed:', response);
    //     const { accessToken } = response.data;
    //     localStorage.setItem('admin_access_token', accessToken);
    //     originalRequest.headers = {
    //       Authorization: `Bearer ${accessToken}`,
    //     };
    //     return axiosClient(originalRequest);
    //   } catch (_error) {
    //     console.error('Refresh token failed:', _error);
    //   }
    // }

    return Promise.reject(error);
  },
);

export { axiosClient };
