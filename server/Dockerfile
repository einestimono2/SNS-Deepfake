# Sử dụng image Node.js chính thức làm base image
FROM node:20.11.1-alpine 

# Thiết lập thư mục làm việc trong container
WORKDIR /usr/src/app

# Sao chép package.json và yarn.lock.json vào thư mục làm việc
COPY package.json yarn.lock ./

# Cài đặt các dependencies trong yarn.lock
RUN yarn install --frozen-lockfile

# Sao chép toàn bộ mã nguồn của ứng dụng vào thư mục làm việc
COPY . .

RUN yarn build

# Expose cổng mà ứng dụng sẽ chạy 
EXPOSE 8888

# Khởi chạy ứng dụng
CMD ["yarn", "dev"]