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
  Parent: 'parent',
  Children: 'children',
  Admin: 'admin'
};
export const accountStatus = {
  Banned: -3,
  Deactivated: -2,
  Pending: -1,
  Inactive: 0,
  Active: 1
};
export const costs = {
  createPost: 10,
  editPost: 10,
  deletePost: 10,
  createMark: 2,
  createFeel: 1
};

export const VerifyCodeStatus = {
  Inactive: 0,
  Active: 1
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
