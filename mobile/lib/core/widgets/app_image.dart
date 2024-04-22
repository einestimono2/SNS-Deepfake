import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

Widget _defaultImage([
  String path = AppImages.errorImage,
  bool isAvatar = false,
  double? radius,
]) {
  final _image = Image.asset(
    path,
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) =>
        _defaultImage(AppImages.errorImage, isAvatar, radius),
  );

  if (isAvatar) {
    return ClipOval(
      child: CircleAvatar(child: _image),
    );
  }

  if (radius != null) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: _image,
    );
  }

  return _image;
}

Widget _mapImageType([
  bool isAvatar = false,
  double? radius,
  Widget? child,
]) {
  if (isAvatar) {
    return CircleAvatar(
      child: ClipOval(child: child),
    );
  }

  if (radius != null) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: child,
    );
  }

  return child!;
}

class AnimatedImage extends StatelessWidget {
  const AnimatedImage({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    required this.url,
    this.isAvatar = false,
    this.radius,
  });

  final double? width;
  final double? height;
  final String url;
  final double? radius;
  final bool isAvatar;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return _mapImageType(isAvatar, radius, _buildFadeInImage());
  }

  CachedNetworkImage _buildFadeInImage() {
    return CachedNetworkImage(
      placeholder: (context, url) => _defaultImage(AppImages.imagePlaceholder),
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      errorWidget: (context, error, stackTrace) =>
          _defaultImage(AppImages.errorImage),
    );
  }
}

class LocalImage extends StatelessWidget {
  final double? width;
  final double? height;
  final String path;
  final double? radius;
  final bool isAvatar;
  final BoxFit fit;

  const LocalImage({
    super.key,
    this.width,
    this.height,
    required this.path,
    this.isAvatar = false,
    this.radius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return _mapImageType(isAvatar, radius, _assetImage());
  }

  Widget _assetImage() {
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          _defaultImage(AppImages.errorImage, isAvatar, radius),
      width: width,
      height: height,
    );
  }
}

class RemoteImage extends StatelessWidget {
  final double? width;
  final double? height;
  final String url;
  final bool isAvatar;
  final double? radius;
  final BoxFit fit;

  const RemoteImage({
    super.key,
    this.width,
    this.height,
    required this.url,
    this.radius,
    this.fit = BoxFit.cover,
    this.isAvatar = false,
  });

  @override
  Widget build(BuildContext context) {
    return _mapImageType(isAvatar, radius, _networkImage());
  }

  Widget _networkImage() {
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) =>
          _defaultImage(AppImages.errorImage, isAvatar, radius),
      loadingBuilder: (
        BuildContext context,
        Widget child,
        ImageChunkEvent? loadingProgress,
      ) {
        if (loadingProgress == null) {
          return child;
        }

        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
      width: width,
      height: height,
    );
  }
}
