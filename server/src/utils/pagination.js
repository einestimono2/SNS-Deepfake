import { BadRequestError } from '../modules/core/error.response.js';

import { Message } from '#constants';

export const getPaginationAttributes = ({ page = 1, size = 30 }) => {
  if (!page) throw new BadRequestError(Message.PAGE_INVALID);
  if (!size) throw new BadRequestError(Message.PAGE_SIZE_INVALID);

  const limit = size || 100;
  const offset = page ? (page - 1) * size : 1;

  return { limit, offset };
};

export const getPaginationSummary = ({ result, page = 1, size = 30 }) => {
  const { count: totalCount, rows: data } = result;

  return {
    data,
    extra: {
      pageIndex: Number(page),
      pageSize: Number(size),
      totalPages: Math.ceil(totalCount / size),
      totalCount
    }
  };
};
