import { Router } from 'express';

import { PostControllers } from './post.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();
router.post('/add_post', isAuthenticated, PostControllers.addPost);
router.get('/details_post/:postId', isAuthenticated, PostControllers.detailsPost);
router.get('/get_list_posts', isAuthenticated, PostControllers.getListPosts);
router.put('/edit_post/:postId', isAuthenticated, PostControllers.editPost);
router.delete('/delete_post/:postId', isAuthenticated, PostControllers.deletePost);
router.post('/report_post/:postId', isAuthenticated, PostControllers.reportPost);
router.get('/get_new_posts', isAuthenticated, PostControllers.getNewPosts);
router.post('/set_viewed_post/:postId', isAuthenticated, PostControllers.setViewedPost);
router.get('/get_list_videos', isAuthenticated, PostControllers.getListVideos);
export const postRouter = router;
