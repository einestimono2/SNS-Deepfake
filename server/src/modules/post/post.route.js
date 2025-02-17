import { Router } from 'express';

import { PostControllers } from './post.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();
router.post('/add_post', isAuthenticated, PostControllers.addPost);
router.get('/details_post/:postId', isAuthenticated, PostControllers.detailsPost);
router.get('/get_list_posts/:groupId', isAuthenticated, PostControllers.getListPosts);
router.put('/edit_post/:postId', isAuthenticated, PostControllers.editPost);
router.delete('/delete_post/:postId', isAuthenticated, PostControllers.deletePost);
router.post('/report_post/:postId', isAuthenticated, PostControllers.reportPost);
router.get('/get_new_posts', isAuthenticated, PostControllers.getNewPosts);
router.post('/set_viewed_post/:postId', isAuthenticated, PostControllers.setViewedPost);
router.get('/get_list_videos/:groupId', isAuthenticated, PostControllers.getListVideos);
router.get('/get_my_posts', isAuthenticated, PostControllers.getMyPosts);

export const postRouter = router;
