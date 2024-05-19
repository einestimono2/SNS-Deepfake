import express from 'express';

import { adminRouter } from './admin/admin.route.js';
import { apiKeyRouter } from './api_key/api_key.route.js';
import { blockRouter } from './block/block.route.js';
import { conversationRouter } from './chat/conversation/conversation.route.js';
import { messageRouter } from './chat/message/message.route.js';
import { commentRouter } from './comment/comment.route.js';
import { NotFoundError } from './core/index.js';
import { friendRouter } from './friend/friend.route.js';
import { groupRouter } from './group/group/group.route.js';
import { mediaRouter } from './media/media.route.js';
import { notificationRouter } from './notification/notification.router.js';
import { postRouter } from './post/post.route.js';
import { searchRouter } from './search/search.route.js';
import { settingRouter } from './setting/setting.route.js';
import { userRouter } from './user/user.route.js';
import { videoScheduleRouter } from './video_schedule/video_schedule.route.js';

import { Message, Strings } from '#constants';
import { getStandardPath } from '#utils';

export const routers = express.Router();

// ----- List routes -----
// ScheduleService.ScheduleTime();
routers.use(`${Strings.API_PREFIX}`, (req, res, next) => {
  res.send('Deployed to production environment successfully');
});
// 1. API Key
routers.use(`${Strings.API_PREFIX}/apikey`, apiKeyRouter);
// 2. Manage images & videos
routers.use(`${Strings.API_PREFIX}/media`, mediaRouter);
// 3. User
routers.use(`${Strings.API_PREFIX}/user`, userRouter);
// 4. Post
routers.use(`${Strings.API_PREFIX}/post`, postRouter);
// 5. Block
routers.use(`${Strings.API_PREFIX}/block`, blockRouter);
// 6. Comment
routers.use(`${Strings.API_PREFIX}/comment`, commentRouter);
// 7. Friend
routers.use(`${Strings.API_PREFIX}/friend`, friendRouter);
// 8. Search
routers.use(`${Strings.API_PREFIX}/search`, searchRouter);
// 9. Setting
routers.use(`${Strings.API_PREFIX}/setting`, settingRouter);
// 10. Notification
routers.use(`${Strings.API_PREFIX}/notification`, notificationRouter);

// 11. Admin
routers.use(`${Strings.API_PREFIX}/admin`, adminRouter);
// 12. Chat
routers.use(`${Strings.API_PREFIX}/conversation`, conversationRouter);
routers.use(`${Strings.API_PREFIX}/message`, messageRouter);
// 13. Group
routers.use(`${Strings.API_PREFIX}/group`, groupRouter);

// 15.VideoSchedule
routers.use(`${Strings.API_PREFIX}/video_schedule`, videoScheduleRouter);

// #. Check Health - test server
routers.use('/health', (_req, res) => {
  res.ok({
    message: '🤗 OK 🤗',
    data: {
      uptime: process.uptime(),
      responseTime: process.hrtime(),
      timestamp: Date.now()
    }
  });
});

//
//! Access video or image *Import trước check Unknown route*
routers.use('/resources', express.static(getStandardPath('../../uploads')));

// -----

//! Unknown route
routers.get('*', (_req, _res, next) => {
  next(new NotFoundError(Message.ROUTE_NOT_FOUND.msg));
});

// -----

// - Export modules
export * from './api_key/api_key.model.js';
export * from './api_key/api_key.service.js';
export * from './core/index.js';
