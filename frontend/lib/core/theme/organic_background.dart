import 'package:flutter/material.dart';

class OrganicBackground extends StatelessWidget {
  final Widget child;

  const OrganicBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Stack(
      children: [
        // Base Background
        Container(
          color: theme.scaffoldBackgroundColor,
        ),
        // Organic Curves
        Positioned.fill(
          child: CustomPaint(
            painter: _OrganicCurvesPainter(
              primaryColor: theme.colorScheme.primary,
              secondaryColor: theme.colorScheme.secondary,
              tertiaryColor: theme.colorScheme.tertiary,
              isDark: isDark,
            ),
          ),
        ),
        // Child Content
        Positioned.fill(
          child: child,
        ),
      ],
    );
  }
}

class _OrganicCurvesPainter extends CustomPainter {
  final Color primaryColor;
  final Color secondaryColor;
  final Color tertiaryColor;
  final bool isDark;

  _OrganicCurvesPainter({
    required this.primaryColor,
    required this.secondaryColor,
    required this.tertiaryColor,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..style = PaintingStyle.fill;
    final opacity = isDark ? 0.05 : 0.08;

    // Top-right blob (Primary forest green)
    final path1 = Path();
    path1.moveTo(size.width * 0.35, 0);
    path1.quadraticBezierTo(
      size.width * 0.65,
      size.height * 0.22,
      size.width,
      size.height * 0.08,
    );
    path1.lineTo(size.width, 0);
    path1.close();

    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryColor.withOpacity(opacity * 1.6),
        secondaryColor.withOpacity(opacity * 0.4),
      ],
    ).createShader(Rect.fromLTWH(size.width * 0.35, 0, size.width * 0.65, size.height * 0.22));
    canvas.drawPath(path1, paint);

    // Bottom-left blob (Earthy brown/tertiary)
    final path2 = Path();
    path2.moveTo(0, size.height * 0.72);
    path2.quadraticBezierTo(
      size.width * 0.32,
      size.height * 0.66,
      size.width * 0.48,
      size.height,
    );
    path2.lineTo(0, size.height);
    path2.close();

    paint.shader = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        tertiaryColor.withOpacity(opacity * 0.9),
        primaryColor.withOpacity(opacity * 0.1),
      ],
    ).createShader(Rect.fromLTWH(0, size.height * 0.66, size.width * 0.48, size.height * 0.34));
    canvas.drawPath(path2, paint);

    // Subtle center-right floating shape (Secondary leaf green)
    final path3 = Path();
    path3.moveTo(size.width, size.height * 0.32);
    path3.cubicTo(
      size.width * 0.72,
      size.height * 0.42,
      size.width * 0.78,
      size.height * 0.58,
      size.width,
      size.height * 0.62,
    );
    path3.close();

    paint.shader = LinearGradient(
      begin: Alignment.topRight,
      end: Alignment.bottomLeft,
      colors: [
        secondaryColor.withOpacity(opacity * 1.3),
        tertiaryColor.withOpacity(opacity * 0.2),
      ],
    ).createShader(Rect.fromLTWH(size.width * 0.72, size.height * 0.32, size.width * 0.28, size.height * 0.3));
    canvas.drawPath(path3, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
