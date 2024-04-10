import { useMutation } from '@tanstack/react-query';

import { ENDPOINTS } from '#/common/constants';
import { axiosClient } from '#/common/services';

export const login = (data) => {
  return axiosClient.post(ENDPOINTS.LOGIN, data);
};

export const useLogin = ({ config }) => {
  return useMutation({
    mutationFn: login,
    ...config,
    // onSuccess: (user, ...rest) => {
    //   // setUser(user);
    //   // options?.onSuccess?.(user, ...rest);
    // },
  });
};
