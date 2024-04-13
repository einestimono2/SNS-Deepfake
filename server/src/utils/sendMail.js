import nodeMailer from 'nodemailer';

export const SendMail = async (email, code) => {
  const transporter = nodeMailer.createTransport({
    host: process.env.SMPT_HOST,
    port: process.env.SMPT_PORT ?? '587',
    service: process.env.SMPT_SERVICE,
    secure: true,
    auth: {
      user: process.env.SMPT_MAIL,
      pass: process.env.SMPT_PASSWORD
    }
  });

  const mailOptions = {
    from: process.env.SMPT_MAIL,
    to: email,
    subject: 'Verify code',
    text: `This is your verify code ${code} `
  };

  await transporter.sendMail(mailOptions);
};
