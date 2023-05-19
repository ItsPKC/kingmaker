// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

typedef BuildPath = Path Function(Size size);

@immutable
class ClipShadowPath extends StatelessWidget {
  final Shadow shadow;
  final BuildPath buildPath;
  final Widget child;

  ClipShadowPath(
      {required this.shadow, required this.buildPath, required this.child});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ClipShadowShadowPainter(
          buildPath: this.buildPath, shadow: this.shadow),
      child: ClipPath(
        clipper: _ClipShadowPathClipper(
          buildPath: this.buildPath,
        ),
        child: child,
      ),
    );
  }
}

class _ClipShadowPathClipper extends CustomClipper<Path> {
  final BuildPath buildPath;
  _ClipShadowPathClipper({
    required this.buildPath,
  });
  @override
  Path getClip(Size size) {
    return this.buildPath(size);
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class _ClipShadowShadowPainter extends CustomPainter {
  final BuildPath buildPath;
  final Shadow shadow;

  _ClipShadowShadowPainter({
    required this.buildPath,
    required this.shadow,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = shadow.toPaint();
    canvas.drawPath(this.buildPath(size), paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
