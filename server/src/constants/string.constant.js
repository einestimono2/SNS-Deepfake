import { dirname, join } from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export const Strings = {
  API_PREFIX: '/api/v1',
  UNUSED_FILE_KEY: '__UNUSED_FILE',
  MEDIA_FILE_PATH: join(__dirname, '../../uploads')
};
