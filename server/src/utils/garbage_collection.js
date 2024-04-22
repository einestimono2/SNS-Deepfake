/* eslint-disable no-unused-vars */
import fs from 'fs';
import path from 'path';

import cron from 'node-cron';

import { logger } from './logger.js';
import { getStandardPath } from './path.js';

import { Strings } from '#constants';

const UPLOADS_FOLDER = getStandardPath('../../uploads');
const IGNORE_FILES = [`.gitkeep`];

/**
 *       *       *       *       *        *       *
 *    second  minute   hour  day/month  month  day/week
 *
 *    https://www.npmjs.com/package/node-cron
 */
const testExpression = '*/30 * * * * *'; // Mỗi 30s
const hourlyExpression = '0 0 * * * *'; // Mỗi 1h
const midnightExpression = '0 0 0 * * *'; // Mỗi 12h đêm

const isDeleteableFile = (filename) => {
  if (IGNORE_FILES.includes(filename)) return false;

  const unusedPrefix = filename.split('___')[0];

  return Strings.UNUSED_FILE_KEY === unusedPrefix;
};

const handleCleaning = (targetDir) => {
  let pending = 1;
  let numCleaned = 1;

  const cleaning = (destination) => {
    fs.readdir(destination, (err, dirContents) => {
      if (err) {
        logger.error(err);
        return;
      }

      for (const fileOrDirPath of dirContents) {
        try {
          // Get Full path
          const fullPath = path.join(destination, fileOrDirPath);

          // Check types
          const stat = fs.statSync(fullPath);

          // It's a sub directory
          if (stat.isDirectory()) {
            if (fs.readdirSync(fullPath).length) {
              pending++;
              cleaning(fullPath);
            }

            // Remove dir - (now empty)
            // fs.rmdirSync(fullPath);
          }
          // It's a file
          else if (isDeleteableFile(fileOrDirPath)) {
            logger.info(`| ${numCleaned++}. ${fileOrDirPath}`);
            fs.unlinkSync(fullPath);
          }
        } catch (error) {
          logger.error(error);
        }
      }

      if (--pending === 0) {
        logger.info('-----> Finish cleaning up images & videos <-----\n');
      }
    });
  };

  logger.info('-----> Start cleaning up images & videos  <-----');
  cleaning(targetDir);
};

export const uploadCleaningSchedule = cron.schedule(midnightExpression, () => handleCleaning(UPLOADS_FOLDER));
