import compression from 'compression';
import cors from 'cors';
import dotenv from 'dotenv';
import express from 'express';
import helmet from 'helmet';
import morgan from 'morgan';

import { initializeFirebaseAdmin } from '#configs';
import { postgreDb } from '#dbs';
import { ErrorMiddleware } from '#middlewares';
import { routers } from '#modules';
import { logger, uploadCleaningSchedule, verifyEnvironmentVariables } from '#utils';

//! Cấu hình env
dotenv.config();

//! Kiểm tra biến môi trường
verifyEnvironmentVariables();

//! Dọn dẹp hình ảnh mỗi 12h đêm hàng ngày
uploadCleaningSchedule.start();

//! Khởi tạo
initializeFirebaseAdmin();
const app = express();

//! Middlewares
// Cache --> Speed up
app.use(
  morgan(':remote-addr :method :url :status :res[content-length] - :response-time ms', {
    stream: {
      // Use the http severity
      write: (message) => logger.http(message)
    }
  })
);
app.use(helmet());
app.use(compression()); // Nén dữ liệu - Giảm kích thước response trả về
const corsOptions = {
  origin: '*', // Thay thế bằng nguồn bạn muốn cho phép
  methods: ['GET', 'PUT', 'POST', 'DELETE'],
  credentials: true
};

app.use(cors(corsOptions));
// app.use(cors()); // Cors - Cross Origin Resource Sharing
app.use(express.json({ limit: '50mb' })); // Read JSON data
app.use(express.urlencoded({ extended: true })); // Can Read another data

//! Database
postgreDb.testConnect();

//! Routes + Unknown route
app.use('', routers);

//! Middleware for errors - gọi cuối cùng
app.use(ErrorMiddleware);

export { app };
