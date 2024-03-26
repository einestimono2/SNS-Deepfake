import { Strings } from '../constants';

export const storage = {
  getAccessToken: () => {
    // return JSON.parse(window.localStorage.getItem(`${storagePrefix}token`) as string);
    return window.localStorage.getItem(Strings.ACCESS_TOKEN);
  },
  setAccessToken: (token) => {
    window.localStorage.setItem(Strings.ACCESS_TOKEN, JSON.stringify(token));
  },
  clearToken: () => {
    window.localStorage.removeItem(Strings.ACCESS_TOKEN);
  },
};
