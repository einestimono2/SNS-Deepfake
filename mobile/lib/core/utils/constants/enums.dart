enum AuthStatus { unknown, authenticated, unauthenticated }

enum SocketStatus { unknown, connected, disconnected }

enum UploadType { image, video }

enum ConversationType { single, group }

enum MessageType { system, text, media, document, link }

enum SearchHistoryType { user, post }

/// Thời gian tối đa, sau thời gian này hiển thị theo mặc định (d/m/y ...)
enum MaxTimeAgoType { none, minute, hour, day, week, month, year }

enum FriendStatus {
  none,
  sent,
  accepted,
  respond,
  unknown
} // unknown ở cuối cùng do sử dụng index để map ra

enum BlockStatus {
  none,
  blocking,
  blocked,
  unknown
} // unknown ở cuối cùng do sử dụng index để map ra
