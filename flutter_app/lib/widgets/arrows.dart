import 'package:flutter/material.dart';

/// custom arrows that get used on main site for graphMessages

/// gives short arrow to the right
class ShortRightArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path_0 = Path();
    path_0.moveTo(0, size.height * 0.4500000);
    path_0.lineTo(size.width * 0.8800000, size.height * 0.4500000);
    path_0.lineTo(size.width * 0.8800000, size.height * 0.3600000);
    path_0.lineTo(size.width * 0.9960000, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.8800000, size.height * 0.6500000);
    path_0.lineTo(size.width * 0.8800000, size.height * 0.5600000);
    path_0.lineTo(0, size.height * 0.5700000);
    path_0.lineTo(0, size.height * 0.4500000);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// gives short arrow to the left
class ShortLeftArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9968800, size.height * 0.4526000);
    path_0.lineTo(size.width * 0.1200000, size.height * 0.4500000);
    path_0.lineTo(size.width * 0.1200000, size.height * 0.3500000);
    path_0.lineTo(0, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.1200000, size.height * 0.6495000);
    path_0.lineTo(size.width * 0.1200000, size.height * 0.5500000);
    path_0.lineTo(size.width * 0.9968800, size.height * 0.5500000);
    path_0.lineTo(size.width * 0.9968800, size.height * 0.4526000);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// gives long arrow to the left
class LongLeftArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.9986667, size.height * 0.4476000);
    path_0.lineTo(size.width * 0.0400000, size.height * 0.4500000);
    path_0.lineTo(size.width * 0.0400000, size.height * 0.3500000);
    path_0.lineTo(0, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.0400000, size.height * 0.6495000);
    path_0.lineTo(size.width * 0.0400000, size.height * 0.5500000);
    path_0.lineTo(size.width * 0.9986667, size.height * 0.5500000);
    path_0.lineTo(size.width * 0.9986667, size.height * 0.4476000);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/// gives long arrow to the right
class LongRightArrow extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint_0 = new Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    Path path_0 = Path();
    path_0.moveTo(size.width * 0.0006000, size.height * 0.4500000);
    path_0.lineTo(size.width * 0.9606667, size.height * 0.4550000);
    path_0.lineTo(size.width * 0.9600000, size.height * 0.3600000);
    path_0.lineTo(size.width * 0.9986667, size.height * 0.5000000);
    path_0.lineTo(size.width * 0.9600000, size.height * 0.6500000);
    path_0.lineTo(size.width * 0.9600000, size.height * 0.5500000);
    path_0.lineTo(size.width * 0.0006000, size.height * 0.5555000);
    path_0.lineTo(size.width * 0.0006000, size.height * 0.4500000);
    path_0.close();

    canvas.drawPath(path_0, paint_0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
