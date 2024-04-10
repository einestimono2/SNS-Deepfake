import { Helmet } from 'react-helmet-async';

export function Head({ title = '', description = '' } = {}) {
  return (
    <Helmet title={title ? `${title} | SNS Deepfake` : undefined} defaultTitle="SNS Deepfake">
      <meta name="description" content={description} />
    </Helmet>
  );
}
