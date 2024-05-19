import { Router } from 'express';

import { FriendControllers } from './friend.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();
router.get('/get_requested_friends', isAuthenticated, FriendControllers.getRequestedFriends);
router.post('/set_request_friend/:targetId', isAuthenticated, FriendControllers.setRequestFriend);
router.post('/set_accept_friend', isAuthenticated, FriendControllers.setAcceptFriend);

router.get('/get_user_friends', isAuthenticated, FriendControllers.getUserFriends);
router.get('/get_suggested_friends', isAuthenticated, FriendControllers.getSuggestedFriends);
router.post('/unfriend/:targetId', isAuthenticated, FriendControllers.setUnfriend);
router.delete('/delete_request_friend/:targetId', isAuthenticated, FriendControllers.delRequestFriend);
router.get('/search_friends', isAuthenticated, FriendControllers.searchFriends);
export const friendRouter = router;
