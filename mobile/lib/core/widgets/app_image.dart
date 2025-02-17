import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../utils/utils.dart';

Widget _defaultImage([
  String path = AppImages.errorImage,
  bool isAvatar = false,
  double? radius,
  BoxFit? fit,
]) {
  final _image = Image.asset(
    path,
    fit: fit,
    errorBuilder: (context, error, stackTrace) =>
        _defaultImage(AppImages.errorImage, isAvatar, radius, fit),
  );

  if (isAvatar) {
    return ClipOval(
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 100,
        child: Image.asset(
          AppImages.avatarPlaceholder,
          fit: fit,
        ),
      ),
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
    this.errorImage = AppImages.errorImage,
  });

  final double? width;
  final double? height;
  final String url;
  final double? radius;
  final bool isAvatar;
  final BoxFit fit;
  final String errorImage;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: _mapImageType(isAvatar, radius, _buildFadeInImage()),
    );
  }

  Widget _buildFadeInImage() {
    return url == ""
        ? _defaultImage(errorImage, isAvatar, radius, fit)
        : CachedNetworkImage(
            placeholder: (context, url) => _defaultImage(
                AppImages.imagePlaceholder, isAvatar, radius, fit),
            imageUrl: url,
            fit: fit,
            errorWidget: (context, error, stackTrace) =>
                _defaultImage(errorImage, isAvatar, radius, fit),
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
  final bool fromFile;

  const LocalImage({
    super.key,
    this.width,
    this.height,
    required this.path,
    this.isAvatar = false,
    this.fromFile = false,
    this.radius,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: _mapImageType(isAvatar, radius, _assetImage()),
    );
  }

  Widget _assetImage() {
    return fromFile
        ? Image.file(
            File(path),
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                _defaultImage(AppImages.errorImage, isAvatar, radius, fit),
          )
        : Image.asset(
            path,
            fit: fit,
            errorBuilder: (context, error, stackTrace) =>
                _defaultImage(AppImages.errorImage, isAvatar, radius, fit),
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
    return SizedBox(
      width: width,
      height: height,
      child: _mapImageType(isAvatar, radius, _networkImage()),
    );
  }

  Widget _networkImage() {
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (context, error, stackTrace) =>
          _defaultImage(AppImages.errorImage, isAvatar, radius, fit),
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
