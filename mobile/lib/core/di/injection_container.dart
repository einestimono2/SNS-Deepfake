import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sns_deepfake/features/video/video.dart';

import '../../config/configs.dart';
import '../../features/app/app.dart';
import '../../features/authentication/authentication.dart';
import '../../features/chat/chat.dart';
import '../../features/friend/friend.dart';
import '../../features/group/group.dart';
import '../../features/news_feed/news_feed.dart';
import '../../features/notification/notification.dart';
import '../../features/profile/profile.dart';
import '../../features/search/search.dart';
import '../../features/upload/upload.dart';
import '../networks/networks.dart';
import '../utils/utils.dart';

final sl = GetIt.instance;

///* registerFactory: Mỗi khi gọi sẽ có một instance mới được tạo ra và trả về
///* registerSingleton: Chỉ tạo ra 1 instance duy nhất, ngay khi khởi động app
///* registerLazySingleton: Khởi tạo vào lần gọi lấy instance đầu tiên, chứ không phải khi app khởi động

Future<void> init() async {
  /* Init variables */
  final localCache = await LocalCache.getInstance();
  final tempDir = await getTemporaryDirectory();
  final cacheOptions = CacheOptions(
    store: HiveCacheStore(
      tempDir.path,
      hiveBoxName: "sns_deepfake_api_cache",
    ),
    /*
    * CachePolicy.forceCache: Trả về cache nếu còn hạn
    * CachePolicy.refreshForceCache: Gọi API kể cả khi có cache
    */
    // todo: cache k hd vs download file
    policy: CachePolicy.noCache, // CachePolicy.forceCache,
    priority: CachePriority.high,
    maxStale: const Duration(days: 30),
    hitCacheOnErrorExcept: [401, 404, 500],
    keyBuilder: (request) =>
        "${localCache.getValue<String>(AppStrings.accessTokenKey)} ${request.uri}",
    allowPostMethod: true, // cache both POST requests
  );

  /* Features */
  _initAppFeature();
  _initSocketFeature();
  _initAuthenticationFeature();
  _initUploadFeature();
  _initChatFeature();
  _initNewsFeedFeature();
  _initFriendFeature();
  _initSearchFeature();
  _initGroupFeature();
  _initProfileFeature();
  _initVideoFeature();
  _initNotificationFeature();

  /**
   * --> External
   */
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => DeviceInfoPlugin());
  sl.registerLazySingleton(() => ImagePicker());
  sl.registerLazySingleton(() => ImageCropper());

  sl.registerLazySingleton(
    () => DioConfigs(localCache: sl()).init(cacheOptions),
  );
  sl.registerLazySingleton(() => tempDir);
  sl.registerLazySingleton(() => cacheOptions);
  sl.registerLazySingleton(() => localCache);
  sl.registerLazySingleton(() => ApiClient(
        dio: sl(),
        cacheOptions: sl(),
      ));
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}

void _initNotificationFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => ListNotificationBloc(
        getListNotificationUC: sl(),
      ));

  /* Use Case */
  sl.registerLazySingleton(() => GetListNotificationUC(repository: sl()));

  /* Repository */
  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(network: sl(), remote: sl()),
  );

  /* Datasource */
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(apiClient: sl()),
  );
}

void _initVideoFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => ListVideoBloc(
        getListVideoUC: sl(),
        feelPostUC: sl(),
        unfeelPostUC: sl(),
        createCommentUC: sl(),
        listCommentBloc: sl(),
        listPostBloc: sl(),
        appBloc: sl(),
      ));

  /* Use Case */
  sl.registerLazySingleton(() => GetListVideoUC(repository: sl()));

  /* Repository */
  sl.registerLazySingleton<VideoRepository>(
    () => VideoRepositoryImpl(network: sl(), remote: sl()),
  );

  /* Datasource */
  sl.registerLazySingleton<VideoRemoteDataSource>(
    () => VideoRemoteDataSourceImpl(apiClient: sl()),
  );
}

void _initProfileFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => ProfileActionBloc(
        updateProfileUC: sl(),
        getUserProfileUC: sl(),
        setBlockUC: sl(),
        unBlockUC: sl(),
        appBloc: sl(),
        userFriendsBloc: sl(),
        userPostsBloc: sl(),
        listFriendBloc: sl(),
        changePasswordUC: sl(),
        buyCoinsUC: sl(),
      ));
  sl.registerLazySingleton(() => MyPostsBloc(
        getMyPosts: sl(),
      ));
  sl.registerLazySingleton(() => UserPostsBloc(
        getUserPostsUC: sl(),
      ));
  sl.registerLazySingleton(() => UserFriendsBloc(
        getUserFriendsUC: sl(),
      ));

  /* Use Case */
  sl.registerLazySingleton(() => UpdateProfileUC(repository: sl()));
  sl.registerLazySingleton(() => GetUserProfileUC(repository: sl()));
  sl.registerLazySingleton(() => GetUserFriendsUC(repository: sl()));
  sl.registerLazySingleton(() => GetUserPostsUC(repository: sl()));
  sl.registerLazySingleton(() => MyPostsUC(repository: sl()));
  sl.registerLazySingleton(() => SetBlockUC(repository: sl()));
  sl.registerLazySingleton(() => UnBlockUC(repository: sl()));
  sl.registerLazySingleton(() => ChangePasswordUC(repository: sl()));
  sl.registerLazySingleton(() => BuyCoinsUC(repository: sl()));

  /* Repository */
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(network: sl(), remote: sl()),
  );

  /* Datasource */
  sl.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(
      apiClient: sl(),
    ),
  );
}

void _initGroupFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => GroupActionBloc(
        createGroupUC: sl(),
        updateGroupUC: sl(),
        getGroupDetailsUC: sl(),
        inviteMemberUC: sl(),
        deleteMemberUC: sl(),
        deleteGroupUC: sl(),
        leaveGroupUC: sl(),
        appBloc: sl(),
        groupPostBloc: sl(),
      ));
  sl.registerLazySingleton(() => ListGroupBloc(
        myGroupsUC: sl(),
        appBloc: sl(),
      ));
  sl.registerLazySingleton(() => GroupPostBloc(
        getListPostUC: sl(),
        createPostUC: sl(),
        appBloc: sl(),
        listPostBloc: sl(),
      ));

  /* Use Case */
  sl.registerLazySingleton(() => CreateGroupUC(repository: sl()));
  sl.registerLazySingleton(() => UpdateGroupUC(repository: sl()));
  sl.registerLazySingleton(() => MyGroupsUC(repository: sl()));
  sl.registerLazySingleton(() => GetGroupDetailsUC(repository: sl()));
  sl.registerLazySingleton(() => InviteMemberUC(repository: sl()));
  sl.registerLazySingleton(() => DeleteMemberUC(repository: sl()));
  sl.registerLazySingleton(() => DeleteGroupUC(repository: sl()));
  sl.registerLazySingleton(() => LeaveGroupUC(repository: sl()));

  /* Repository */
  sl.registerLazySingleton<GroupRepository>(
    () => GroupRepositoryImpl(network: sl(), remote: sl()),
  );

  /* Datasource */
  sl.registerLazySingleton<GroupRemoteDataSource>(
    () => GroupRemoteDataSourceImpl(
      apiClient: sl(),
    ),
  );
}

void _initNewsFeedFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => PostActionBloc(
        createPostUC: sl(),
        editPostUC: sl(),
        deletePostUC: sl(),
        getPostDetailsUC: sl(),
        createCommentUC: sl(),
        feelPostUC: sl(),
        unfeelPostUC: sl(),
        reportPostUC: sl(),
        listPostBloc: sl(),
        appBloc: sl(),
        myPostsBloc: sl(),
        listCommentBloc: sl(),
        groupPostBloc: sl(),
        searchPostBloc: sl(),
        userPostsBloc: sl(),
      ));
  sl.registerLazySingleton(() => ListPostBloc(getListPostUC: sl()));
  sl.registerLazySingleton(() => ListCommentBloc(getListCommentUC: sl()));

  /* Use Case */
  sl.registerLazySingleton(() => CreatePostUC(repository: sl()));
  sl.registerLazySingleton(() => GetListPostUC(repository: sl()));
  sl.registerLazySingleton(() => EditPostUC(repository: sl()));
  sl.registerLazySingleton(() => GetPostDetailsUC(repository: sl()));
  sl.registerLazySingleton(() => DeletePostUC(repository: sl()));
  sl.registerLazySingleton(() => GetListCommentUC(repository: sl()));
  sl.registerLazySingleton(() => CreateCommentUC(repository: sl()));
  sl.registerLazySingleton(() => FeelPostUC(repository: sl()));
  sl.registerLazySingleton(() => UnfeelPostUC(repository: sl()));
  sl.registerLazySingleton(() => ReportPostUC(repository: sl()));

  /* Repository */
  sl.registerLazySingleton<PostRepository>(
    () => PostRepositoryImpl(network: sl(), remote: sl()),
  );

  /* Datasource */
  sl.registerLazySingleton<PostRemoteDataSource>(
    () => PostRemoteDataSourceImpl(
      apiClient: sl(),
      uploadRemote: sl(),
    ),
  );
}

void _initFriendFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => RequestedFriendsBloc(
        getRequestedFriendsUC: sl(),
      ));
  sl.registerLazySingleton(
      () => SuggestedFriendsBloc(getSuggestedFriendsUC: sl()));
  sl.registerLazySingleton(() => ListFriendBloc(
        getListFriendUC: sl(),
      ));
  sl.registerLazySingleton(() => FriendActionBloc(
        acceptRequestUC: sl(),
        refuseRequestUC: sl(),
        sendRequestUC: sl(),
        unfriendUC: sl(),
        unsentRequestUC: sl(),
      ));

  /* Use Case */
  sl.registerLazySingleton(() => GetRequestedFriendsUC(repository: sl()));
  sl.registerLazySingleton(() => GetSuggestedFriendsUC(repository: sl()));
  sl.registerLazySingleton(() => GetListFriendUC(repository: sl()));
  sl.registerLazySingleton(() => AcceptRequestUC(repository: sl()));
  sl.registerLazySingleton(() => RefuseRequestUC(repository: sl()));
  sl.registerLazySingleton(() => SendRequestUC(repository: sl()));
  sl.registerLazySingleton(() => UnsentRequestUC(repository: sl()));
  sl.registerLazySingleton(() => UnfriendUC(repository: sl()));

  /* Repository */
  sl.registerLazySingleton<FriendRepository>(
    () => FriendRepositoryImpl(network: sl(), remote: sl()),
  );

  /* Datasource */
  sl.registerLazySingleton<FriendRemoteDataSource>(
    () => FriendRemoteDataSourceImpl(apiClient: sl()),
  );
}

void _initSearchFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => SearchUserBloc(
        searchUserUC: sl(),
        searchHistoryBloc: sl(),
      ));
  sl.registerLazySingleton(() => SearchPostBloc(
        searchPostUC: sl(),
        searchHistoryBloc: sl(),
      ));
  sl.registerLazySingleton(() => SearchHistoryBloc(
        getSearchHistoryUC: sl(),
        deleteSearchHistoryUC: sl(),
      ));

  /* Use Case */
  sl.registerLazySingleton(() => SearchUserUC(repository: sl()));
  sl.registerLazySingleton(() => SearchPostUC(repository: sl()));
  sl.registerLazySingleton(() => GetSearchHistoryUC(repository: sl()));
  sl.registerLazySingleton(() => DeleteSearchHistoryUC(repository: sl()));

  /* Repository */
  sl.registerLazySingleton<SearchRepository>(
    () => SearchRepositoryImpl(network: sl(), remote: sl()),
  );

  /* Datasource */
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(apiClient: sl()),
  );
}

void _initChatFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => MyConversationsBloc(myConversationUC: sl()));
  sl.registerLazySingleton(() => ConversationDetailsBloc(
        myConversationsBloc: sl(),
        appBloc: sl(),
        getConversationDetailsUC: sl(),
        createConversationUC: sl(),
        seenConversationUC: sl(),
        getConversationMessagesUC: sl(),
        getConversationIdUC: sl(),
        updateConversationUC: sl(),
      ));
  sl.registerLazySingleton(
    () => MessageBloc(
      sendMessageUC: sl(),
      createConversationUC: sl(),
      appBloc: sl(),
    ),
  );

  /* Use Case */
  sl.registerLazySingleton(() => MyConversationUC(repository: sl()));
  sl.registerLazySingleton(() => GetConversationDetailsUC(repository: sl()));
  sl.registerLazySingleton(() => GetConversationMessagesUC(repository: sl()));
  sl.registerLazySingleton(() => SendMessageUC(repository: sl()));
  sl.registerLazySingleton(() => SeenConversationUC(repository: sl()));
  sl.registerLazySingleton(() => CreateConversationUC(repository: sl()));
  sl.registerLazySingleton(() => GetConversationIdUC(repository: sl()));
  sl.registerLazySingleton(() => UpdateConversationUC(repository: sl()));

  /* Repository */
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(network: sl(), remote: sl()),
  );

  /* Datasource */
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(apiClient: sl(), uploadRemote: sl()),
  );
}

void _initUploadFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => UploadBloc(uploadImageUC: sl()));
  sl.registerLazySingleton(() => DownloadBloc(
        dio: sl(),
        cacheOptions: sl(),
      ));

  /* Use Case */
  sl.registerLazySingleton(() => UploadImageUC(repository: sl()));

  /* Repository */
  sl.registerLazySingleton<UploadRepository>(
    () => UploadRepositoryImpl(network: sl(), remote: sl()),
  );

  /* Datasource */
  sl.registerLazySingleton<UploadRemoteDataSource>(
    () => UploadRemoteDataSourceImpl(apiClient: sl()),
  );
}

void _initAuthenticationFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => UserBloc(
        loginUC: sl(),
        logoutUC: sl(),
        signUpUC: sl(),
        appBloc: sl(),
        verifyOtpUC: sl(),
        resendOtpUC: sl(),
        finishProfileUC: sl(),
        forgotPasswordUC: sl(),
        resetPasswordUC: sl(),
      ));

  /* Use Case */
  sl.registerLazySingleton(() => GetUserUC(repository: sl()));
  sl.registerLazySingleton(() => LoginUC(repository: sl()));
  sl.registerLazySingleton(() => LogoutUC(repository: sl()));
  sl.registerLazySingleton(() => SignUpUC(repository: sl()));
  sl.registerLazySingleton(() => VerifyOtpUC(repository: sl()));
  sl.registerLazySingleton(() => ResendOtpUC(repository: sl()));
  sl.registerLazySingleton(() => FinishProfileUC(repository: sl()));
  sl.registerLazySingleton(() => ForgotPasswordUC(repository: sl()));
  sl.registerLazySingleton(() => ResetPasswordUC(repository: sl()));

  /* Repository */
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(network: sl(), remote: sl(), local: sl()),
  );

  /* Datasource */
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(apiClient: sl()),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(localCache: sl()),
  );
}

void _initAppFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => AppBloc(getUserUC: sl(), localCache: sl()));
}

void _initSocketFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => SocketBloc(
        myConversationsBloc: sl(),
        conversationDetailsBloc: sl(),
        messageBloc: sl(),
      ));
}
