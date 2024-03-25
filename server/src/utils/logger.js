import winston from 'winston';
import DailyRotateFile from 'winston-daily-rotate-file';

import { app } from '#configs';
import { LoggerColors } from '#constants';

winston.addColors(LoggerColors);

const format = winston.format.combine(
  winston.format.timestamp({
    format: 'HH:mm:ss'
  }),
  // winston.format.splat(),
  winston.format.colorize({ all: true }),
  // winston.format.prettyPrint(),
  winston.format.printf((info) => `[${info.timestamp}] [${app.env.toUpperCase()}] [${info.level}]: ${info.message}`)
);

const exceptionHandlers = [
  new DailyRotateFile({
    datePattern: 'YYYY-MM-DD',
    filename: 'exception.log',
    auditFile: 'logs/logs-audit.json',
    dirname: 'logs/%DATE%',
    zippedArchive: true,
    maxSize: '5m',
    maxFiles: '7d'
  })
];

const rejectionHandlers = [
  new DailyRotateFile({
    datePattern: 'YYYY-MM-DD',
    filename: 'rejection.log',
    auditFile: 'logs/logs-audit.json',
    dirname: 'logs/%DATE%',
    zippedArchive: true,
    maxSize: '5m',
    maxFiles: '7d'
  })
];

const infoWinston = winston.createLogger({
  level: 'info',
  // defaultMeta: { service: 'log-service' }, // Thêm object mặc định vào
  format,
  transports: [
    // Info logs
    new DailyRotateFile({
      level: 'info',
      datePattern: 'YYYY-MM-DD',
      filename: 'info.log',
      auditFile: 'logs/logs-audit.json',
      dirname: 'logs/%DATE%',
      zippedArchive: true,
      maxSize: '15m',
      maxFiles: '7d'
    }),
    new winston.transports.Console()
  ],
  exceptionHandlers,
  rejectionHandlers
  // handleRejections: true,
  // handleExceptions: true
});

const errorWinston = winston.createLogger({
  level: 'error',
  // defaultMeta: { service: 'log-service' }, // Thêm object mặc định vào
  format,
  transports: [
    // Error logs
    new DailyRotateFile({
      level: 'error',
      datePattern: 'YYYY-MM-DD',
      filename: 'error.log',
      auditFile: 'logs/logs-audit.json',
      dirname: 'logs/%DATE%',
      zippedArchive: true,
      maxSize: '10m',
      maxFiles: '7d'
    }),
    new winston.transports.Console()
  ],
  exceptionHandlers,
  rejectionHandlers
  // handleRejections: true,
  // handleExceptions: true
});

const warnWinston = winston.createLogger({
  level: 'warn',
  // defaultMeta: { service: 'log-service' }, // Thêm object mặc định vào
  format,
  transports: [
    // Warn logs
    new DailyRotateFile({
      level: 'warn',
      datePattern: 'YYYY-MM-DD',
      filename: 'warn.log',
      auditFile: 'logs/logs-audit.json',
      dirname: 'logs/%DATE%',
      zippedArchive: true,
      maxSize: '5m',
      maxFiles: '7d'
    }),
    new winston.transports.Console()
  ],
  exceptionHandlers,
  rejectionHandlers
  // handleRejections: true,
  // handleExceptions: true
});

const httpWinston = winston.createLogger({
  level: 'http',
  // defaultMeta: { service: 'log-service' }, // Thêm object mặc định vào
  format,
  transports: [
    // Http logs
    new DailyRotateFile({
      level: 'http',
      datePattern: 'YYYY-MM-DD',
      filename: 'http.log',
      auditFile: 'logs/logs-audit.json',
      dirname: 'logs/%DATE%',
      zippedArchive: true,
      maxSize: '15m',
      maxFiles: '7d'
    }),
    new winston.transports.Console()
  ],
  exceptionHandlers,
  rejectionHandlers
  // handleRejections: true,
  // handleExceptions: true
});

const debugWinston = winston.createLogger({
  level: 'debug',
  // defaultMeta: { service: 'log-service' }, // Thêm object mặc định vào
  format,
  transports: [
    // Debug logs
    new DailyRotateFile({
      level: 'debug',
      datePattern: 'YYYY-MM-DD',
      filename: 'debug.log',
      auditFile: 'logs/logs-audit.json',
      dirname: 'logs/%DATE%',
      zippedArchive: true,
      maxSize: '5m',
      maxFiles: '7d'
    }),
    new winston.transports.Console()
  ],
  exceptionHandlers,
  rejectionHandlers
  // handleRejections: true,
  // handleExceptions: true
});

export const logger = {
  info: (message) => {
    return infoWinston.info(message);
  },
  http: (message) => {
    return httpWinston.http(message);
  },
  debug: (message) => {
    return debugWinston.debug(message);
  },
  warn: (message) => {
    return warnWinston.warn(message);
  },
  error: (message) => {
    return errorWinston.error(message);
  }
};

// export const logger = winston.createLogger({
//   level: isDevelopment() ? 'debug' : 'warn',
//   levels: LoggerLevels,
//   format,
//   transports,
//   exceptionHandlers: [
//     new DailyRotateFile({
//       datePattern: 'YYYY-MM-DD',
//       filename: 'exception.log',
//       auditFile: 'logs/logs-audit.json',
//       dirname: 'logs/%DATE%',
//       zippedArchive: true,
//       maxSize: '5m',
//       maxFiles: '7d'
//     })
//   ],
//   rejectionHandlers: [
//     new DailyRotateFile({
//       datePattern: 'YYYY-MM-DD',
//       filename: 'rejection.log',
//       auditFile: 'logs/logs-audit.json',
//       dirname: 'logs/%DATE%',
//       zippedArchive: true,
//       maxSize: '5m',
//       maxFiles: '7d'
//     })
//   ]
// });
