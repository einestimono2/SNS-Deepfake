import { Router } from 'express';

import { SearchControllers } from './search.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();
router.get('/search_post', isAuthenticated, SearchControllers.searchPost);
router.get('/search_user', isAuthenticated, SearchControllers.searchUser);
// router.get('/search_group', isAuthenticated, SearchControllers.searchGroup);
router.get('/get_saved_search', isAuthenticated, SearchControllers.getSavedSearches);
router.delete('/delete_saved_search', isAuthenticated, SearchControllers.deleteSavedSearch);
router.get('/search_hashtag', isAuthenticated, SearchControllers.searchHashtag);
export const searchRouter = router;
