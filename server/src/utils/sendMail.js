import nodemailer from 'nodemailer';

export const SendMail = async (email, code) => {
  const transporter = nodemailer.createTransport({
    host: process.env.SMPT_HOST,
    port: process.env.SMPT_PORT ?? '587',
    service: process.env.SMPT_SERVICE,
    secure: true,
    auth: {
      user: process.env.SMPT_MAIL,
      pass: process.env.SMPT_PASSWORD
    }
  });

  const expiryTime = '30 minutes';

  const mailOptions = {
    from: process.env.SMPT_MAIL,
    to: email,
    subject: 'Welcome to Deepfake SNS',
    html: `<!DOCTYPE html>
    <html lang="en">
    <head>
      <meta charset="UTF-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Email Verification Code</title>
      <style>
        /* Styles for better email layout and readability */
        body {
          font-family: Arial, sans-serif;
          line-height: 1.6;
          color: #333;
        }
        .container {
          max-width: 600px;
          margin: 0 auto;
          padding: 20px;
          border: 1px solid #ccc;
          border-radius: 5px;
        }
        .logo {
          text-align: center;
        }
        .logo img {
          width: 100px;
          height: auto;
        }
        .message {
          margin-top: 20px;
        }
        .code {
          text-align: center;
          font-size: 24px;
          font-weight: bold;
          margin-top: 20px;
        }
      </style>
    </head>
    <body>
      <div class="container">
        <div class="message">
          <p>Dear ${email},</p>
          <p>Your verification code is:</p>
          <p class="code">${code}</p>
          <p>Please use this code to verify your email address. This code will expire in ${expiryTime}.</p>
          <p>If you didn't request this code, you can ignore this email.</p>
        </div>
      </div>
    </body>
    </html>`
  };

  await transporter.sendMail(mailOptions);
};
