import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:screenly/config/text_config.dart';
import 'package:screenly/config/theme_config.dart';

class NowPlayingSection extends StatelessWidget {
  const NowPlayingSection({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.amber,
      Colors.blueAccent,
      Colors.deepOrangeAccent,
      Colors.teal,
      Colors.purpleAccent,
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 16,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'Now Playing',
            style: heading4TextStyle.copyWith(color: whiteColor),
          ),
        ),
        FlutterCarousel(
          options: FlutterCarouselOptions(
            height: 440,
            showIndicator: true,
            enlargeCenterPage: true,
            enlargeStrategy: CenterPageEnlargeStrategy.height,
            enlargeFactor: 128 / 440,
            viewportFraction: 0.9,
            enableInfiniteScroll: true,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 3),
            autoPlayAnimationDuration: const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            slideIndicator: CircularSlideIndicator(
              slideIndicatorOptions: SlideIndicatorOptions(
                indicatorRadius: 4,
                itemSpacing: 12,
                currentIndicatorColor: whiteColor,
                indicatorBackgroundColor: Colors.grey.withValues(alpha: 0.5),
              ),
            ),
          ),
          items: colors.map((color) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 6),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(16),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
