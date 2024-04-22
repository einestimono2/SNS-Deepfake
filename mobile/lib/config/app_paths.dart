import 'package:flutter_dotenv/flutter_dotenv.dart';

class Endpoints {
  Endpoints._();

  static final String baseDevelopmentUrl = dotenv.env['SERVER_DEV_URL'] ?? "";
  static final String baseProductionUrl = dotenv.env['SERVER_PROD_URL'] ?? "";

  static final String prefixEndpoint = dotenv.env['API_PREFIX'] ?? "";

  static const String verify = '/user/verify';
  static const String finishProfile = '/user/change_profile_after_signup';
  static const String login = '/user/login';
  static const String register = '/user/register';
  static const String verifyOtp = '/user/check_verify_code';
  static const String resendOtp = '/user/get_verify_code';

  static const String uploadImages = '/media/images';
}

class Routes {
  Routes._();

  static final splash = Route(name: "splash", path: "/");

  static final login = Route(name: "login", path: "/login");

  static final signup = Route(name: "signup", path: "/signup");

  static final forgot = Route(name: "forgot", path:"/forgot");

  static final verify = Route(name: "verify", path: "/verify");

  static final finish = Route(name: "finish", path: "/finish");

  static final newsFeed = Route(name: "news_feed", path: "/news_feed");

  static final chat = Route(name: "chat", path: "/chat");

  static final video = Route(name: "video", path: "/video");

  static final profile = Route(name: "profile",path: "/profile");

  static final notification = Route(name: "notification", path: "/notification");

  static final friend = Route(name: "friend", path: "/friend");
  static final suggestedFriends = Route(name: "suggested_friends", path: "suggested");
  static final requestedFriends = Route(name: "requested_friends", path: "requested");
  static final allFriend = Route(name: "all_friend", path: "all");
  static final searchFriend = Route(name: "search_friend", path: "search");
}

class Route {
  String name;
  String path;

  Route({
    required this.name,
    required this.path,
  });
}
