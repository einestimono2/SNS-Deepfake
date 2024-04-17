import { AccountStatus, CategoryType, costs } from '#constants';
// Lấy Category của bài post
export const getCategory = (post) => {
  if (post.video) {
    return { id: String(CategoryType.Videos), has_name: '2', name: 'videos' };
  }
  if (post.images.length) {
    return { id: String(CategoryType.Posts), has_name: '0', name: 'home' };
  }
  return { id: String(CategoryType.Posts), has_name: '0', name: 'home' };
};
// Kiểm tra có block hay không
export const getIsBlocked = (post) => {
  return Boolean(post.author.blocked.length || post.author.blocking.length);
};
// Kiểm tra có được edit hay không
export const getCanEdit = (post, user) => {
  if (post.author.id === user.id && post.author.status !== AccountStatus.Inactive && user.coins >= costs.editPost) {
    return '1';
  }
  return '0';
};
// Kiểm tra có được banned hay không
export const getBanned = (post) => {
  return post.author.status === AccountStatus.Banned ? '1' : '0';
};

export const getCanMark = (post, user) => {
  if (post.author.id !== user.id) {
    if (post.author.status === AccountStatus.Inactive) {
      return '-2';
    }
    if (user.coins < costs.createMark) {
      return '-4';
    }
    if (post.markOfUser) {
      if (post.markOfUser.editable) {
        return '2';
      }
      return '0';
    }
    return '1';
  }
  return '-1';
};

export const getCanRate = (post, user) => {
  if (post.author.id !== user.id) {
    if (post.author.status === AccountStatus.Inactive) {
      return '-2';
    }
    if (user.coins < costs.createFeel) {
      return '-4';
    }
    if (post.feelOfUser) {
      if (post.feelOfUser.editable) {
        return '2';
      }
      return '0';
    }
    return '1';
  }
  return '-1';
};
