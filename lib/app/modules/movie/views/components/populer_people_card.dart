import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

class PopularPeopleCard extends StatelessWidget {
  final String? name;
  final String? profileUrl;
  final VoidCallback? onTap;

  const PopularPeopleCard({
    super.key,
    this.name,
    this.profileUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const cardSize = 128.0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardSize,
        child: Column(
          spacing: 8,
          children: [
            Container(
              width: cardSize,
              height: cardSize,
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: profileUrl != null && profileUrl!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: profileUrl!,
                      fit: BoxFit.cover,
                      width: cardSize,
                      height: cardSize,
                      placeholder: (context, url) => Container(
                        color: const Color(0xFF1E1E1E),
                        child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: primaryColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: const Color(0xFF1E1E1E),
                        child: const Icon(
                          Icons.person_rounded,
                          color: Colors.white38,
                          size: 40,
                        ),
                      ),
                    )
                  : const Center(
                      child: Icon(
                        Icons.person_rounded,
                        color: Colors.white38,
                        size: 40,
                      ),
                    ),
            ),
            Text(
              name ?? 'Name',
              textAlign: TextAlign.center,
              style: paragraphSmallTextStyle.copyWith(color: whiteColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
