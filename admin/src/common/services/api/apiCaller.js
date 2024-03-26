import dayjs from 'dayjs';
import { toast } from 'react-toastify';

function defaultErrorHandler(error) {
  const now = dayjs().format('YYY-MM-DD HH:mm:ss');
  console.error(`[${now}] An error occurred: `, error);
  toast.error(error);
}

export async function apiCaller({ request, errorHandler = defaultErrorHandler }) {
  try {
    const response = await request();
    return response;
  } catch (error) {
    errorHandler(error);
  }
  return null;
}
