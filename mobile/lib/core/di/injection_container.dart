import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:get_it/get_it.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../config/configs.dart';
import '../../features/app/app.dart';
import '../../features/authentication/authentication.dart';
import '../../features/upload/upload.dart';
import '../networks/networks.dart';

final sl = GetIt.instance;

///* registerFactory: Mỗi khi gọi sẽ có một instance mới được tạo ra và trả về
///* registerSingleton: Chỉ tạo ra 1 instance duy nhất, ngay khi khởi động app
///* registerLazySingleton: Khởi tạo vào lần gọi lấy instance đầu tiên, chứ không phải khi app khởi động

Future<void> init() async {
  /* Init variables */
  final sharedPreferences = await SharedPreferences.getInstance();

  /* Features */
  _initAppFeature();
  _initAuthenticationFeature();
  _initUploadFeature();

  /**
   * --> External
   */
  sl.registerLazySingleton(() => sharedPreferences);
  sl.registerLazySingleton(() => Connectivity());
  sl.registerLazySingleton(() => DeviceInfoPlugin());
  sl.registerLazySingleton(() => ImagePicker());
  sl.registerLazySingleton(() => ImageCropper());

  sl.registerLazySingleton(
    () => DioConfigs(connectivity: sl(), localCache: sl()).init(),
  );
  sl.registerLazySingleton(() => LocalCache(sharedPreferences: sl()));
  sl.registerLazySingleton(() => ApiClient(dio: sl())); // ~ DioConfigs
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));
}

/* =============================== FEATURES =============================== */

void _initUploadFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => UploadBloc(
        uploadImageUC: sl(),
      ));

  /* Use Case */
  sl.registerLazySingleton(() => UploadImageUC(repository: sl()));

  /* Repository */
  sl.registerLazySingleton<UploadRepository>(
    () => UploadRepositoryImpl(
      network: sl(),
      remote: sl(),
    ),
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
        signUpUC: sl(),
        appBloc: sl(),
        verifyOtpUC: sl(),
        resendOtpUC: sl(),
        finishProfileUC: sl(),
      ));

  /* Use Case */
  sl.registerLazySingleton(() => GetUserUC(repository: sl()));
  sl.registerLazySingleton(() => LoginUC(repository: sl()));
  sl.registerLazySingleton(() => SignUpUC(repository: sl()));
  sl.registerLazySingleton(() => VerifyOtpUC(repository: sl()));
  sl.registerLazySingleton(() => ResendOtpUC(repository: sl()));
  sl.registerLazySingleton(() => FinishProfileUC(repository: sl()));

  /* Repository */
  sl.registerLazySingleton<UserRepository>(
    () => UserRepositoryImpl(
      network: sl(),
      remote: sl(),
      local: sl(),
    ),
  );

  /* Datasource */
  sl.registerLazySingleton<UserRemoteDataSource>(
    () => UserRemoteDataSourceImpl(localCache: sl(), apiClient: sl()),
  );
  sl.registerLazySingleton<UserLocalDataSource>(
    () => UserLocalDataSourceImpl(localCache: sl()),
  );
}

void _initAppFeature() {
  /* Bloc */
  sl.registerLazySingleton(() => AppBloc(
        getUserUC: sl(),
        localCache: sl(),
      ));
}
