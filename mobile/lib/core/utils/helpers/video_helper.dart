import 'package:mime/mime.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

// Future<String?> getVideoThumbnail(
//   String path, {
//   ImageFormat format = ImageFormat.JPEG,
//   int quality = 25,
// }) async {
//   return await VideoThumbnail.thumbnailFile(
//     video: path,
//     imageFormat: format,
//     quality: quality,
//   );
// }

bool fileIsVideo(String path) {
  return lookupMimeType(path)?.startsWith("video") ?? false;
}
