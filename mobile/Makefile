run_prod:
	flutter run --flavor production --target lib/main_production.dart

run_dev:
	flutter run --flavor development --target lib/main_development.dart

setup_app_splash:
	flutter pub run flutter_native_splash:create

remove_app_splash:
	flutter pub run flutter_native_splash:remove

setup_app_icon:
	flutter pub run flutter_launcher_icons

# IOS sử dụng - thay vì _
change_package_name:
	flutter pub run change_app_package_name:main com.hust.sns_deepfake

get_app_name:
	flutter pub run rename getAppName --targets ios,android,macos,windows,linux

set_app_name:
	flutter pub run rename setAppName --targets ios,android,macos,windows,linux --value "SNS Deepfake"

get_bundle_id:
	flutter pub run rename getBundleId --targets ios,android,macos,windows,linux

set_bundle_id:
	flutter pub run rename setBundleId --targets ios,android,macos,windows,linux --value "com.hust.sns_deepfake"

# flutter pub run rename setBundleId --targets macos --value "com.hust.sns-deepfake"

# android:label="@string/app_name"
# android:name="${applicationName}"

# flutterfire config --project=deepfake-25d31 --out=lib/firebase_options_development.dart --ios-bundle-id=com.hust.sns-deepfake-development --android-app-id=com.hust.sns_deepfake.development

# flutterfire config --project=deepfake-25d31 --out=lib/firebase_options_production.dart --ios-bundle-id=com.hust.sns-deepfake --android-app-id=com.hust.sns_deepfake