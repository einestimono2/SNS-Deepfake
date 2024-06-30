import { SearchServices } from './search.service.js';

import { CatchAsyncError } from '#middlewares';
import { getPaginationAttributes, getPaginationSummary } from '#utils';

export class SearchControllers {
  static searchPost = CatchAsyncError(async (req, res) => {
    const result = await SearchServices.searchPost({
      userId: req.userPayload.userId,
      ...getPaginationAttributes(req.query),
      keyword: req.query.keyword,
      cache: req.query.cache
    });

    res.ok(
      getPaginationSummary({
        ...req.query,
        result
      })
    );
  });

  static searchUser = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const data = await SearchServices.searchUser({
      userId,
      ...getPaginationAttributes(req.query),
      keyword: req.query.keyword,
      cache: req.query.cache
    });

    res.ok(
      getPaginationSummary({
        ...req.query,
        result: data
      })
    );
  });

  static getSavedSearches = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;

    const data = await SearchServices.getSavedSearches(userId, getPaginationAttributes(req.query));

    res.ok(
      getPaginationSummary({
        ...req.query,
        result: data
      })
    );
  });

  static deleteSavedSearch = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    await SearchServices.deleteSavedSearch(userId, req.body);
    res.ok({
      message: 'Xóa lịch sử tìm kiếm thành công'
    });
  });

  static searchHashtag = CatchAsyncError(async (req, res) => {
    const { userId } = req.userPayload;
    const data = await SearchServices.searchHashtag(userId, ...getPaginationAttributes(req.query), req.body);
    res.ok(
      getPaginationSummary({
        ...req.query,
        data
      })
    );
  });
}
