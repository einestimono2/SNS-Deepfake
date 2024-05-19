export const LoggerLevels = {
  error: 0,
  warn: 1,
  info: 2,
  http: 3,
  debug: 4
};

export const LoggerColors = {
  error: 'red',
  warn: 'yellow',
  info: 'green',
  http: 'magenta',
  debug: 'white'
};

export const EnvTypes = {
  prod: 'prod',
  dev: 'dev'
};

export const Roles = {
  Parent: '1',
  Children: '0',
  Admin: '2'
};

export const AccountStatus = {
  Banned: -3,
  Deactivated: -2,
  Pending: -1, // Khi chưa hoàn thiện profile
  Inactive: 0, // Khi chưa xác thực OTP
  Active: 1 // Khi đã hoàn thiện profile
};

export const costs = {
  createPost: 10,
  editPost: 10,
  deletePost: 10,
  createMark: 2,
  createFeel: 1,
  sharePost: 5
};

export const MarkType = {
  Trust: 1,
  Fake: 0
};

export const FeelType = {
  Kudos: 1,
  Disappointed: 0
};

export const CategoryType = {
  Posts: 0,
  Friends: 1,
  Videos: 2,
  Notifications: 3,
  Settings: 4
};

export const NotificationType = {
  FriendRequest: 1,
  FriendAccepted: 2,
  PostAdded: 3,
  PostUpdated: 4,
  PostFelt: 5,
  PostMarked: 6,
  MarkCommented: 7,
  VideoAdded: 8,
  PostCommented: 9,
  PlusCoins: 10
};

export const ConversationType = {
  Single: 'single',
  Group: 'group'
};

export const MessageType = {
  System: 'system',
  Text: 'text',
  Media: 'media',
  Document: 'document',
  Link: 'link'
};

export const SearchType = {
  User: 'user',
  Post: 'post',
  Group: 'group'
};
