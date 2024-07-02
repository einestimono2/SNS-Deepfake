class Endpoints {
  Endpoints._();

  static const String serverIP = "http://192.168.1.25";
  // static const String serverIP = "http://10.10.0.157";

  static const String baseDevelopmentUrl = "$serverIP:8888";
  static const String baseProductionUrl = "http://localhost:8888";

  static const String socketDevelopmentUrl = "$serverIP:8888";
  static const String socketProductionUrl = "http://localhost:8888";

  static const String prefixEndpoint = "api/v1";

  static const String verify = '/user/verify';
  static const String finishProfile = '/user/change_profile_after_signup';
  static const String login = '/user/login';
  static const String logout = '/user/logout';
  static const String register = '/user/register';
  static const String verifyOtp = '/user/check_verify_code';
  static const String resendOtp = '/user/get_verify_code';
  static const String changePassword = '/user/change_password';

  static const String updateProfile = '/user/set_user_info';
  static const String getProfile = '/user/get_user_info/:userId';

  static const String block = '/block/set_block/:targetId';
  static const String unblock = '/block/unblock/:targetId';

  static const String createPost = '/post/add_post';
  static const String listPost = '/post/get_list_posts/:groupId';
  static const String listVideo = '/post/get_list_videos/:groupId';
  static const String detailsPost = '/post/details_post/:postId'; // Get
  static const String myPosts = '/post/get_my_posts'; // Get
  static const String editPost = '/post/edit_post/:postId'; // PUT
  static const String deletePost = '/post/delete_post/:postId'; // DELETE
  static const String reportPost = '/post/report_post/:postId'; // POST
  static const String viewedPost = '/post/set_viewed_post/:postId'; // POST

  static const String listComment = '/comment/get_mark_comment/:postId';
  static const String createComment = '/comment/set_mark_comment/:postId';
  static const String feelPost = '/comment/feel/:postId';
  static const String unfeelPost = '/comment/delete_feel/:postId';

  static const String createGroup = '/group/create_group'; // POST
  static const String myGroups = '/group/my_list_group'; // GET
  static const String groupDetails = '/group/detail_group/:groupId'; // GET
  static const String updateGroup = '/group/update_group/:groupId'; // PUT
  static const String addMember = '/group/add_members/:groupId'; // POST
  static const String deleteMember = '/group/delete_members/:groupId'; // DELETE
  static const String deleteGroup = '/group/delete_group/:groupId'; // DELETE
  static const String leaveGroup = '/group/leave_group/:groupId'; // DELETE

  static const String uploadImages = '/media/images';
  static const String uploadVideos = '/media/videos';

  static const String myConversations = '/conversation/list';
  static const String createConversation = '/conversation/create';
  static const String getSingleConversationByMembers = '/conversation/get_single_conversation_by_members';
  static const String conversationDetails = '/conversation/details/:id';
  static const String seenConversation = '/conversation/seen/:id';
  static const String sendMessage = '/message/create';
  static const String conversationMessages = '/message/list/:conversationId';

  static const String searchUser = '/search/search_user'; // GET
  static const String searchPost = '/search/search_post'; // GET
  static const String searchHistory = '/search/get_saved_search'; // GET
  static const String deleteHistory = '/search/delete_saved_search'; // DELETE

  static const String requestedFriend = '/friend/get_requested_friends'; // GET
  static const String suggestedFriend = '/friend/get_suggested_friends'; // GET
  static const String listFriend = '/friend/get_user_friends'; // GET
  static const String acceptRequest =
      '/friend/set_accept_friend/:targetId'; // GET
  static const String refuseRequest =
      '/friend/delete_request_friend/:targetId'; // DELETE
  static const String sendRequest =
      '/friend/set_request_friend/:targetId'; // GET
  static const String unsentRequest =
      '/friend/un_request_friend/:targetId'; // DELETE
  static const String unfriend = '/friend/unfriend/:targetId'; // GET

  static const String buyCoins = '/setting/buy_coins';
}

class Routes {
  Routes._();

  static final splash = Route(name: "splash", path: "/");

  static final login = Route(name: "login", path: "/login");

  static final signup = Route(name: "signup", path: "/signup");

  static final forgot = Route(name: "forgot", path: "/forgot");
  
  static final resetPassword = Route(name: "resetPassword", path: "/resetPassword");

  static final verify = Route(name: "verify", path: "/verify");

  static final finish = Route(name: "finish", path: "/finish");

  static final newsFeed = Route(name: "news_feed", path: "/news_feed");
  static final createPost = Route(name: "create_post", path: "create");
  static final editPost = Route(name: "edit_post", path: "edit/:id");
  static final postDetails =
      Route(name: "post_details", path: "post_details/:id");

  static final myGroup = Route(name: 'my_group', path: '/my_group');
  static final createGroup = Route(name: 'create_group', path: 'create_group');
  static final createGroupPost =
      Route(name: 'create_group_post', path: 'create_group_post');
  static final groupDetails =
      Route(name: 'group_details', path: 'group_details/:id');
  static final manageGroup = Route(name: 'manage_group', path: 'manage_group');
  static final inviteMember =
      Route(name: 'invite_member', path: 'invite_member');

  static final chat = Route(name: "chat", path: "/chat");
  static final videoCall = Route(name: "videoCall", path: "videoCall");
  static final conversation =
      Route(name: "conversation", path: "conversation/:id");
  static final createConversation =
      Route(name: "create_conversation", path: "create_conversation");

  static final video = Route(name: "video", path: "/video");

  static final profile = Route(name: "profile", path: "/profile");
  static final setting = Route(name: "setting", path: "setting");
  static final myProfile = Route(name: "myProfile", path: "myProfile");
  static final updateProfile =
      Route(name: "update_profile", path: "update_profile");
  static final buyCoins = Route(name: "buy_coins", path: "buy_coins");
  static final videoDF = Route(name: "video_df", path: "video_df");
  static final createVideoDF =
      Route(name: "create_video_df", path: "create_video_df");
  static final updatePassword =
      Route(name: "update_password", path: "update_password");
  static final otherProfile = Route(
    name: "otherProfile",
    path: "/other_profile/:id",
  );
  static final otherFriends =
      Route(name: "other_profile_friends", path: "friends");

  static final notification = Route(
    name: "notification",
    path: "/notification",
  );

  static final friend = Route(
    name: "friend",
    path: "/friend",
  );
  static final suggestedFriends = Route(
    name: "suggested_friends",
    path: "suggested",
  );
  static final requestedFriends = Route(
    name: "requested_friends",
    path: "requested",
  );
  static final allFriend = Route(name: "all_friend", path: "all");
}

class Route {
  String name;
  String path;

  Route({
    required this.name,
    required this.path,
  });
}
