// lib/widgets/signs_layer.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../models/sign.dart';

class SignsLayer extends StatelessWidget {
  final List<Sign> signs;
  final Map<String, String> precachedSvgs;

  SignsLayer({
    required this.signs,
    required this.precachedSvgs,
  });

  Widget _buildSvgPicture(String assetName, {double? width, double? height, BoxFit? fit}) {
    if (precachedSvgs.containsKey(assetName)) {
      return SvgPicture.string(
        precachedSvgs[assetName]!,
        width: width,
        height: height,
        fit: fit ?? BoxFit.contain,
      );
    }
    return SvgPicture.asset(
      assetName,
      width: width,
      height: height,
      fit: fit ?? BoxFit.contain,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: signs.map((sign) {
        return Positioned(
          left: sign.left,
          top: sign.top,
          child: IgnorePointer(
            child: _buildSvgPicture(
              sign.assetName,
              width: sign.size,
              height: sign.size,
            ),
          ),
        );
      }).toList(),
    );
  }
}
