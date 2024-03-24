import winston from 'winston';
import DailyRotateFile from 'winston-daily-rotate-file';

import { app, isDevelopment } from '#configs';
import { LoggerColors, LoggerLevels } from '#constants';

winston.addColors(LoggerColors);

const format = winston.format.combine(
  winston.format.timestamp({
    format: 'HH:mm:ss'
  }),
  winston.format.align(),
  winston.format.colorize({ all: true }),
  winston.format.prettyPrint(),
  winston.format.printf((info) => `[${info.timestamp}] [${app.env.toUpperCase()}] ${info.level}: ${info.message}`)
);

const transports = [
  new winston.transports.Http({ host: 'localhost', port: 8080 }),
  // new winston.transports.File({
  //   filename: 'logs/error.log',
  //   level: 'error'
  // })
  new DailyRotateFile({
    datePattern: 'YYYY-MM-DD',
    filename: '%DATE%.log',
    auditFile: 'logs/logs.json',
    dirname: 'logs',
    zippedArchive: true,
    maxSize: '20m',
    maxFiles: '14d'
  }),
  new winston.transports.Console()
  // new winston.transports.File({ filename: 'logs/all.log' })
];

export const logger = winston.createLogger({
  level: isDevelopment() ? 'debug' : 'warn',
  LoggerLevels,
  format,
  transports
});
