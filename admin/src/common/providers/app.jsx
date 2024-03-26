import { Button } from 'antd';
import React from 'react';
import { ErrorBoundary } from 'react-error-boundary';
import { QueryClientProvider } from 'react-query';
import { ReactQueryDevtools } from 'react-query/devtools';
import { BrowserRouter } from 'react-router-dom';
import { ToastContainer } from 'react-toastify';

import { Spinner } from '#/common/components';
import { queryClient } from '#/common/configs';

function ErrorFallback() {
  return (
    <div className="text-red-500 w-screen h-screen flex flex-col justify-center items-center" role="alert">
      <h2 className="text-lg font-semibold">Ooops, something went wrong :( </h2>
      <Button className="mt-4" onClick={() => window.location.assign(window.location.origin)}>
        Refresh
      </Button>
    </div>
  );
}

export function AppProvider({ children }) {
  return (
    <React.Suspense
      fallback={
        <div className="flex items-center justify-center w-screen h-screen">
          <Spinner size="xl" />
        </div>
      }
    >
      <ErrorBoundary FallbackComponent={ErrorFallback}>
        {/* <HelmetProvider> */}
        <QueryClientProvider client={queryClient}>
          {import.meta.env.NODE_ENV !== 'test' && <ReactQueryDevtools />}
          {/* <AuthProvider> */}
          <BrowserRouter>{children}</BrowserRouter>
          {/* </AuthProvider> */}
          <ToastContainer theme="colored" newestOnTop />
        </QueryClientProvider>
        {/* </HelmetProvider> */}
      </ErrorBoundary>
    </React.Suspense>
  );
}
