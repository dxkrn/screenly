import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

class TvshowCard extends StatelessWidget {
  final String? title;
  final String? posterUrl;
  final VoidCallback? onTap;
  final num? voteAvg, voteCount;
  final double? width, height;
  final bool showTypeBadge;

  const TvshowCard({
    super.key,
    this.title,
    this.posterUrl,
    this.onTap,
    this.voteAvg,
    this.voteCount,
    this.width,
    this.height,
    this.showTypeBadge = false,
  });

  String _formatVoteCount(num count) {
    if (count >= 1000000) {
      return '${(count / 1000000).toStringAsFixed(1)}M';
    } else if (count >= 1000) {
      return '${(count / 1000).toStringAsFixed(1)}k';
    }
    return count.toString();
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = width ?? (3 / 4) * 240.0;
    final cardHeight = height ?? 240.0;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: cardWidth,
        child: Column(
          spacing: 8,
          children: [
            Container(
                width: cardWidth,
                height: cardHeight,
                decoration: BoxDecoration(
                  color: Colors.black45,
                  borderRadius: BorderRadius.circular(24),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: posterUrl != null && posterUrl!.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: posterUrl!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
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
                                  Icons.movie_outlined,
                                  color: Colors.white38,
                                  size: 40,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),
                    if (showTypeBadge)
                      Positioned(
                        top: 0,
                        left: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: primaryColor,
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(16),
                            ),
                          ),
                          child: Text(
                            'Tv',
                            style: paragraphSmallTextStyle.copyWith(
                              color: blackColor,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                  ],
                )),
            Text(
              title ?? 'title',
              textAlign: TextAlign.center,
              style: paragraphSmallTextStyle.copyWith(color: whiteColor),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (voteAvg != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.star_rounded,
                    color: primaryColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    voteAvg!.toStringAsFixed(1),
                    style: heading6TextStyle.copyWith(
                      color: whiteColor,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (voteCount != null && voteCount! > 0) ...[
                    const SizedBox(width: 4),
                    Text(
                      '(${_formatVoteCount(voteCount!)})',
                      style: paragraphSmallTextStyle.copyWith(
                        color: Colors.white54,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
      ),
    );
  }
}
