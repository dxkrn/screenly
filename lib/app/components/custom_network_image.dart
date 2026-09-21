import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:screenly/config/theme_config.dart';
import 'package:screenly/utils/helpers/path_helper.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.imgUrl,
    this.indicatorColor,
  });

  final String imgUrl;
  final Color? indicatorColor;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imgUrl,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: CircularProgressIndicator(
          value: downloadProgress.progress,
          color: indicatorColor ?? primaryColor,
        ),
      ),
      errorWidget: (context, url, error) => SvgPicture.asset(
        setImagePath('no-image', ImageType.svg),
      ),
    );
  }
}
