import 'package:flutter/material.dart';
import '../models/card_back_asset.dart';

/// Widget responsible for rendering card backs
class CardBackWidget extends StatelessWidget {
  final CardBackAsset cardBackAsset;
  final double size;
  final bool isSmallScreen;

  const CardBackWidget({
    Key? key,
    required this.cardBackAsset,
    required this.size,
    required this.isSmallScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.12),
        border: Border.all(
          color: cardBackAsset.borderColor,
          width: isSmallScreen ? 2.0 : 2.5,
        ),
        color: cardBackAsset.backgroundColor,
        image: DecorationImage(
          image: AssetImage(cardBackAsset.assetPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
