import { useNavigate } from 'react-router-dom';

import { Layout } from '../components/Layout';
import { LoginForm } from '../components/LoginForm';

export function Login() {
  const navigate = useNavigate();

  return (
    <Layout title="Đăng nhập">
      <LoginForm onSuccess={() => navigate('/dashboard', { replace: true })} />
    </Layout>
  );
}
