import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

export const getStandardPath = (_path) => {
  const __filename = fileURLToPath(import.meta.url);

  const __dirname = path.dirname(__filename);

  return path.join(__dirname, _path);
};

export const getRootPath = () => {
  const __filename = fileURLToPath(import.meta.url);

  const __dirname = path.dirname(__filename);

  return path.join(__dirname, '..', '..');
};

export const getMediaFromPath = (_path) => {
  const root = getRootPath();

  const parts = _path.split('/');

  return path.join(root, 'uploads', parts[2], parts[3]);
};

export const getOrCreateDestination = (_path) => {
  const destination = getStandardPath(_path);
  if (!fs.existsSync(destination)) {
    fs.mkdirSync(destination);
  }

  return destination;
};
