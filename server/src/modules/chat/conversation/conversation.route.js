import { Router } from 'express';

import { ConversationController } from './conversation.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();

// - [POST] Add
router.post('/create', isAuthenticated, ConversationController.createConversation);

router.post(
  '/get_single_conversation_by_members',
  isAuthenticated,
  ConversationController.getSingleConversationByMembers
);

// - [GET] List
router.get('/list', isAuthenticated, ConversationController.getMyConversations);

// - [GET] SEEN
router.get('/seen/:id', isAuthenticated, ConversationController.seenConversation);

router
  .route('/details/:id')
  // - [GET] Details
  .get(isAuthenticated, ConversationController.getConversationDetails)
  // - [DELETE] Delete
  .delete(isAuthenticated, ConversationController.deleteConversation);

export const conversationRouter = router;
