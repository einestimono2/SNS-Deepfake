import { Button, ConfigProvider, Form, Image, Input } from 'antd';

import { COLOR_NO_BACKGROUND_LOGO } from '#/assets';

export function LoginForm({ onSuccess }) {
  const handleLogin = async () => {
    onSuccess();
  };

  return (
    <ConfigProvider
      theme={{
        components: {
          Input: {
            activeBg: 'rgba(255,255,255,0.5)',
            activeBorderColor: 'rgba(255,255,255,0.5)',
            hoverBg: 'rgba(255,255,255,0.5)',
            hoverBorderColor: 'rgba(255,255,255,0.5)',
          },
        },
      }}
    >
      <div className="text-center">
        <Image width={100} src={COLOR_NO_BACKGROUND_LOGO} preview={false} />

        <div className="mb-8 mt-0">
          <div className="font-bold text-3xl">SNS DEEPFAKE</div>
          <div className="text-base text-gray-600">- Quản lý hệ thống -</div>
        </div>
      </div>

      <Form layout="vertical" size="large" onFinish={handleLogin}>
        <Form.Item
          name="username"
          initialValue="admin"
          rules={[{ required: true, message: 'Hãy nhập tài khoản!' }]}
          label="Tài khoản"
        >
          <Input
            placeholder="Tài khoản quản lý"
            className="bg-[rgb(255,255,255,0.35)] border-[rgb(255,255,255,0.35)]"
          />
        </Form.Item>

        <Form.Item
          name="password"
          initialValue="123456"
          label="Mật khẩu"
          rules={[
            { required: true, message: 'Hãy nhập mật khẩu!' },
            {
              type: 'string',
              min: 6,
              message: 'Mật khẩu ít nhất 6 kí tự!',
            },
          ]}
        >
          <Input.Password
            className="bg-[rgb(255,255,255,0.35)] border-[rgb(255,255,255,0.35)]"
            placeholder="Mật khẩu"
          />
        </Form.Item>

        <Form.Item className="text-center mt-14">
          <Button type="primary" htmlType="submit" block className="rounded-md bg-[#070810]" loading={false}>
            Đăng nhập
          </Button>
        </Form.Item>
      </Form>
    </ConfigProvider>
  );
}
