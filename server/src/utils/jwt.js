import jwt from 'jsonwebtoken';

export const signToken = (userId, deviceId) => {
  const token = jwt.sign({ userId, deviceId }, process.env.JWT_SECRET, {
    expiresIn: '1h'
  });
  return token;
};

export const signRefreshToken = (userId) => {
  const refreshToken = jwt.sign({ _id: userId }, process.env.REFRESH_TOKEN_SECRET, {
    expiresIn: '7d'
  });
  return refreshToken;
};
