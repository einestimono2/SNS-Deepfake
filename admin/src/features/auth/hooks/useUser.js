import { useQuery } from '@tanstack/react-query';

import { ENDPOINTS, Strings } from '#/common/constants';
import { axiosClient } from '#/common/services';
import { storage } from '#/common/utils';

export const getUser = async () => {
  if (storage.getAccessToken()) {
    const data = await axiosClient.get(ENDPOINTS.PROFILE);

    return data;
  }

  return null;
};

export const useUser = ({ config }) => useQuery({ queryKey: [Strings.USER_KEY], queryFn: () => getUser(), ...config });
