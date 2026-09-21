import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class SkeletonLoader extends StatelessWidget {
  const SkeletonLoader({
    super.key,
    required this.enabled,
    required this.child,
  });

  final Widget child;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      effect: const ShimmerEffect(
        baseColor: Color.fromARGB(255, 211, 223, 230),
        highlightColor: Color.fromARGB(255, 240, 245, 248),
        duration: Duration(seconds: 2),
      ),
      textBoneBorderRadius: const TextBoneBorderRadius.fromHeightFactor(.9),
      enabled: enabled,
      child: child,
    );
  }
}
