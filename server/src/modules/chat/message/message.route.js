import { Router } from 'express';

import { MessageController } from './message.controller.js';

import { isAuthenticated } from '#middlewares';

const router = Router();

// - [POST] Add
router.post('/create', isAuthenticated, MessageController.createMessage);

// - [GET] List
router.get('/list/:conversationId', isAuthenticated, MessageController.getConversationMessages);

// // - [GET] SEEN
// router.get('/seen/:id', isAuthenticated, ConversationController.seenConversation);

router
  .route('/details/:id')
  // - [GET] Details
  .patch(isAuthenticated, MessageController.updateMessage);

export const messageRouter = router;
