class Endpoints {
  Endpoints._();

  static const String serverIP = "http://192.168.1.2";

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

  static const String createPost = '/post/add_post';
  static const String listPost = '/post/get_list_posts/:groupId';
  static const String detailsPost = '/post/details_post/:postId'; // Get
  static const String editPost = '/post/edit_post/:postId'; // PUT
  static const String deletePost = '/post/delete_post/:postId'; // DELETE
  static const String reportPost = '/post/report_post/:postId'; // POST
  static const String viewedPost = '/post/set_viewed_post/:postId'; // POST

  static const String uploadImages = '/media/images';
  static const String uploadVideos = '/media/videos';

  static const String myConversations = '/conversation/list';
  static const String createConversation = '/conversation/create';
  static const String conversationDetails = '/conversation/details/:id';
  static const String seenConversation = '/conversation/seen/:id';
  static const String sendMessage = '/message/create';
  static const String conversationMessages = '/message/list/:conversationId';

  static const String searchUser = '/search/search_user'; // GET
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
  static const String unfriend = '/friend/unfriend/:targetId'; // GET
}

class Routes {
  Routes._();

  static final splash = Route(name: "splash", path: "/");

  static final login = Route(name: "login", path: "/login");

  static final signup = Route(name: "signup", path: "/signup");

  static final forgot = Route(name: "forgot", path: "/forgot");

  static final verify = Route(name: "verify", path: "/verify");

  static final finish = Route(name: "finish", path: "/finish");

  static final newsFeed = Route(name: "news_feed", path: "/news_feed");
  static final createPost = Route(name: "create_post", path: "create");

  static final chat = Route(name: "chat", path: "/chat");
  static final conversation =
      Route(name: "conversation", path: "conversation/:id");

  static final video = Route(name: "video", path: "/video");

  static final profile = Route(name: "profile", path: "/profile");
  static final setting = Route(name: "setting", path: "setting");

  static final otherProfile =
      Route(name: "otherProfile", path: "/other_profile/:id");

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
