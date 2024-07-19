import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:some_app/src/core/styles/app_colors.dart';

class ArrowTabBarIndicator extends Decoration {
  final BoxPainter _painter;
  ArrowTabBarIndicator({
    double width = 20,
    double height = 10,
    required Color color,
  }) : _painter = _ArrowPainter(width, height);

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) => _painter;
}

class _ArrowPainter extends BoxPainter {
  final Paint _paint;
  final double width;
  final double height;

  _ArrowPainter(this.width, this.height)
      : _paint = Paint()
          ..color = AppColors.main
          ..isAntiAlias = true;

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration cfg) {
    Path trianglePath = Path();
    if (cfg.size != null) {
      Offset centerTop = Offset(cfg.size!.width / 2, cfg.size!.height - height) + offset;
      Offset bottomLeft = Offset(cfg.size!.width / 2 - (width / 2), cfg.size!.height) + offset;
      Offset bottomRight = Offset(cfg.size!.width / 2 + (width / 2), cfg.size!.height) + offset;

      trianglePath.moveTo(bottomLeft.dx, bottomLeft.dy);
      trianglePath.lineTo(bottomRight.dx, bottomRight.dy);
      trianglePath.lineTo(centerTop.dx, centerTop.dy);
      trianglePath.lineTo(bottomLeft.dx, bottomLeft.dy);

      trianglePath.close();
      canvas.drawPath(trianglePath, _paint);
    }
  }
}
