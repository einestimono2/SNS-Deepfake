// export const generateCode = () => {
//   const characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'; // Bao gồm chữ cái và số
//   const codeLength = 6;
//   const codes = new Set(); // Dùng Set để đảm bảo mã không trùng nhau

//   while (codes.size < codeLength) {
//     let code = '';
//     for (let i = 0; i < codeLength; i++) {
//       const randomIndex = Math.floor(Math.random() * characters.length);
//       code += characters[randomIndex];
//     }
//     codes.add(code);
//   }

//   return Array.from(codes)[0]; // Trả về mã xác thực đầu tiên trong Set
// };
export const generateVerifyCode = (length) => {
  let code = '';
  for (let i = 0; i < length; i++) {
    const c = Math.floor(Math.random() * 9);
    code += c;
  }
  return code;
};
