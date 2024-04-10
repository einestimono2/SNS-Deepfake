import { useMutation, useQuery, useQueryClient } from '@tanstack/react-query';
import React from 'react';

// export interface AuthProviderProps {
//   children: React.ReactNode;
// }

export function configureAuth({ userFn, userKey = ['authenticated-user'], loginFn, registerFn, logoutFn }) {
  //
  const useUser = (options) => useQuery(userKey, userFn, options);

  const useLogin = (options) => {
    const queryClient = useQueryClient();

    const setUser = React.useCallback((data) => queryClient.setQueryData(userKey, data), [queryClient]);

    return useMutation({
      mutationFn: loginFn,
      ...options,
      onSuccess: (user, ...rest) => {
        setUser(user);
        options?.onSuccess?.(user, ...rest);
      },
    });
  };

  const useRegister = (options) => {
    const queryClient = useQueryClient();

    const setUser = React.useCallback((data) => queryClient.setQueryData(userKey, data), [queryClient]);

    return useMutation({
      mutationFn: registerFn,
      ...options,
      onSuccess: (user, ...rest) => {
        setUser(user);
        options?.onSuccess?.(user, ...rest);
      },
    });
  };

  const useLogout = (options) => {
    const queryClient = useQueryClient();

    const setUser = React.useCallback((data) => queryClient.setQueryData(userKey, data), [queryClient]);

    return useMutation({
      mutationFn: logoutFn,
      ...options,
      onSuccess: (...args) => {
        setUser(null);
        options?.onSuccess?.(...args);
      },
    });
  };

  function AuthLoader({
    children,
    renderLoading,
    renderUnauthenticated,
    renderError = (error) => <>{JSON.stringify(error)}</>,
  }) {
    const { isSuccess, isFetched, status, data, error } = useUser();

    if (isSuccess) {
      if (renderUnauthenticated && !data) {
        return renderUnauthenticated();
      }
      return <>{children}</>;
    }

    if (!isFetched) {
      return renderLoading();
    }

    if (status === 'error') {
      return renderError(error);
    }

    return null;
  }

  return {
    useUser,
    useLogin,
    useRegister,
    useLogout,
    AuthLoader,
  };
}
