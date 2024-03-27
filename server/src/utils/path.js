import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

export const getStandardPath = (_path) => {
  const __filename = fileURLToPath(import.meta.url);

  const __dirname = path.dirname(__filename);

  return path.join(__dirname, _path);
};

export const getOrCreateDestination = (_path) => {
  const destination = getStandardPath(_path);
  if (!fs.existsSync(destination)) {
    fs.mkdirSync(destination);
  }

  return destination;
};
