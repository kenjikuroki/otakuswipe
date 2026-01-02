// lib/widgets/ad_placeholder.dart

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdPlaceholder extends StatelessWidget {
  final AdSize adSize;

  const AdPlaceholder({
    super.key,
    this.adSize = AdSize.banner,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: adSize.width.toDouble(),
      height: adSize.height.toDouble(),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4), // 少し角丸に
          ),
          child: const Center(
            child: Text(
              "Loading Ad...",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black26,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
