import { Router } from 'express';

import { FriendControllers } from './friend.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();
router.get('/get_requested_friends', isAuthenticated, FriendControllers.getRequestedFriends);
router.get('/set_request_friend/:targetId', isAuthenticated, FriendControllers.setRequestFriend);
router.get('/set_accept_friend/:targetId', isAuthenticated, FriendControllers.setAcceptFriend);

router.get('/get_user_friends', isAuthenticated, FriendControllers.getUserFriends);
router.get('/get_suggested_friends', isAuthenticated, FriendControllers.getSuggestedFriends);
router.get('/unfriend/:targetId', isAuthenticated, FriendControllers.setUnfriend);
router.delete('/delete_request_friend/:targetId', isAuthenticated, FriendControllers.delRequestFriend);
router.delete('/un_request_friend/:targetId', isAuthenticated, FriendControllers.unRequestFriend);
router.get('/search_friends', isAuthenticated, FriendControllers.searchFriends);
export const friendRouter = router;
