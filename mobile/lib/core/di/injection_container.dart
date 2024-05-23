import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';
import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../../config/configs.dart';
import '../../features/app/app.dart';
import '../../features/authentication/authentication.dart';
import '../../features/chat/chat.dart';
import '../../features/friend/friend.dart';
import '../../features/news_feed/news_feed.dart';
import '../../features/search/search.dart';
import '../../features/upload/upload.dart';
import '../networks/networks.dart';

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
    policy: CachePolicy.refreshForceCache,
    priority: CachePriority.high,
    maxStale: const Duration(days: 30),
    hitCacheOnErrorExcept: [401, 404, 500],
    keyBuilder: (request) => request.uri.toString(),
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

void _initNewsFeedFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => PostActionBloc(
        createPostUC: sl(),
        editPostUC: sl(),
        deletePostUC: sl(),
        getPostDetailsUC: sl(),
        listPostBloc: sl(),
        appBloc: sl(),
      ));
  sl.registerLazySingleton(() => ListPostBloc(getListPostUC: sl()));

  /* Use Case */
  sl.registerLazySingleton(() => CreatePostUC(repository: sl()));
  sl.registerLazySingleton(() => GetListPostUC(repository: sl()));
  sl.registerLazySingleton(() => EditPostUC(repository: sl()));
  sl.registerLazySingleton(() => GetPostDetailsUC(repository: sl()));
  sl.registerLazySingleton(() => DeletePostUC(repository: sl()));

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
      ));

  /* Use Case */
  sl.registerLazySingleton(() => GetRequestedFriendsUC(repository: sl()));
  sl.registerLazySingleton(() => GetSuggestedFriendsUC(repository: sl()));
  sl.registerLazySingleton(() => GetListFriendUC(repository: sl()));
  sl.registerLazySingleton(() => AcceptRequestUC(repository: sl()));
  sl.registerLazySingleton(() => RefuseRequestUC(repository: sl()));
  sl.registerLazySingleton(() => SendRequestUC(repository: sl()));
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
  sl.registerLazySingleton(() => SearchHistoryBloc(
        getSearchHistoryUC: sl(),
        deleteSearchHistoryUC: sl(),
      ));

  /* Use Case */
  sl.registerLazySingleton(() => SearchUserUC(repository: sl()));
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
        seenConversationUC: sl(),
        getConversationMessagesUC: sl(),
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

  /* Repository */
  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(network: sl(), remote: sl()),
  );

  /* Datasource */
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(apiClient: sl()),
  );
}

void _initUploadFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => UploadBloc(uploadImageUC: sl()));

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
      ));

  /* Use Case */
  sl.registerLazySingleton(() => GetUserUC(repository: sl()));
  sl.registerLazySingleton(() => LoginUC(repository: sl()));
  sl.registerLazySingleton(() => LogoutUC(repository: sl()));
  sl.registerLazySingleton(() => SignUpUC(repository: sl()));
  sl.registerLazySingleton(() => VerifyOtpUC(repository: sl()));
  sl.registerLazySingleton(() => ResendOtpUC(repository: sl()));
  sl.registerLazySingleton(() => FinishProfileUC(repository: sl()));

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
