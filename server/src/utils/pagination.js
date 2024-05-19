import { BadRequestError } from '../modules/core/error.response.js';

import { Message } from '#constants';

export const getPaginationAttributes = ({ page, size }) => {
  if (page && page < 1) throw new BadRequestError(Message.PAGE_INVALID);
  if (size && size < 1) throw new BadRequestError(Message.PAGE_SIZE_INVALID);

  const limit = size || null;
  const offset = page ? (page - 1) * size : null;

  return { limit, offset };
};

export const getPaginationSummary = ({ result, page, size }) => {
  const { count: totalCount, rows: data } = result;
  return {
    data,
    extra: {
      pageIndex: page ? Number(page) : 1,
      pageSize: size ? Number(size) : null,
      totalPages: size && totalCount !== 0 ? Math.ceil(totalCount / size) : 1,
      totalCount
    }
  };
};
