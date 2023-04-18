import 'dart:math' as math;
import 'dart:math';

import 'package:flutter/material.dart';

extension on num {
  /// This is an extension we created so we can easily convert a value  /// to a radian value
  double get radians => (this * math.pi) / 180.0;
}

class AnalogClockPaintApple extends CustomPainter {
  DateTime dateTime = DateTime.now();

  AnalogClockPaintApple();

  @override
  void paint(Canvas canvas, Size size) {
    final double centerX = size.width / 2;
    final double centerY = size.height / 2;
    final double radius = min(centerX, centerY);

    // Draw black background
    Paint backgroundPaint = Paint()..color = Colors.black;
    canvas.drawRect(Offset.zero & size, backgroundPaint);

    canvas.save();

    /// We shift the coordinates to the center of the screen
    canvas.translate(centerX, centerY);

    /// Clock outline
    final clockPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;

    // Total angle of a circle is 360
    const circumference = 360;

    // Total ticks to display
    const totalTicks = 12;

    /// The angle between each tick
    const unitAngle = circumference / totalTicks;

    for (int i = 0; i <= 11; i++) {
      /// calculates the angle of each tick index
      /// reason for adding 90 degree to the angle is
      /// so that the ticks starts from
      final angle = -90.radians + (i * unitAngle).radians;

      /// Draws the tick for each angle
      canvas.drawLine(
        Offset.fromDirection(angle, radius * 0.90),
        Offset.fromDirection(angle, radius),
        Paint()
          ..color = Colors.white
          ..strokeWidth = 2
          ..strokeCap = StrokeCap.butt,
      );

      // Draw numbers
      TextSpan span = TextSpan(
        style: const TextStyle(fontSize: 14, color: Colors.white),
        text: '${(i == 0 ? 12 : i)}',
      );

      TextPainter tp = TextPainter(
        text: span,
        textScaleFactor: 2.3,
        textAlign: TextAlign.left,
        textDirection: TextDirection.ltr,
      );
      tp.layout();

      Offset offset = Offset.fromDirection(angle, radius * 0.76);
      offset = offset.translate(-tp.width / 2, -tp.preferredLineHeight / 2);
      tp.paint(canvas, offset);
    }

    for (int i = 0; i <= 239; i++) {
      /// calculates the angle of each tick index
      /// reason for adding 90 degree to the angle is
      /// so that the ticks starts from
      if (i % 4 != 0) {
        final angle = 90.radians + (i * 360 / 240).radians;

        /// Draws the tick for each angle
        canvas.drawLine(
          Offset.fromDirection(angle, radius * 0.95),
          Offset.fromDirection(angle, radius),
          Paint()
            ..color = Colors.white38
            ..strokeWidth = 1
            ..strokeCap = StrokeCap.butt,
        );
      }
    }

    for (int i = 0; i <= 59; i++) {
      /// calculates the angle of each tick index
      /// reason for adding 90 degree to the angle is
      /// so that the ticks starts from
      final angle = 90.radians + (i * 360 / 60).radians;

      /// Draws the tick for each angle
      canvas.drawLine(
        Offset.fromDirection(angle, radius * 0.90),
        Offset.fromDirection(angle, radius),
        Paint()
          ..color = Colors.white38
          ..strokeWidth = 1
          ..strokeCap = StrokeCap.butt,
      );
    }

    final angle = -90.radians + (3 * unitAngle).radians;

    // Draw numbers
    TextSpan span = TextSpan(
      style: const TextStyle(fontSize: 12, color: Colors.orange),
      text: '${dateTime.day}',
    );

    TextPainter tp = TextPainter(
      text: span,
      textScaleFactor: 2.3,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    tp.layout();

    Offset offset = Offset.fromDirection(angle, radius * 0.4);
    offset = offset.translate(-tp.width / 2, -tp.preferredLineHeight / 2);
    tp.paint(canvas, offset);

    //
    //
    // WORK IN PROGRESS START
    //
    //

    canvas.restore();
    canvas.save();

    /// Draw mini minutes clock
    final double centerMinutesX = size.width / 2;
    final double centerMinutesY = size.height / 2.4;
    final double radiusMinutes = min(centerMinutesX, centerMinutesY) * 0.25;
    canvas.translate(centerMinutesX, centerMinutesY);

    for (int i = 0; i <= 59; i++) {
      final angle = -90.radians + (i * 360 / 60).radians;

      /// Draws the tick for each angle
      if (i % 10 != 0) {
        if (i % 2 != 0) {
          canvas.drawLine(
            Offset.fromDirection(angle, radiusMinutes * 0.90),
            Offset.fromDirection(angle, radiusMinutes),
            Paint()
              ..color = Colors.white38
              ..strokeWidth = 1
              ..strokeCap = StrokeCap.butt,
          );
        } else {
          canvas.drawLine(
            Offset.fromDirection(angle, radiusMinutes * 0.85),
            Offset.fromDirection(angle, radiusMinutes),
            Paint()
              ..color = Colors.white38
              ..strokeWidth = 1
              ..strokeCap = StrokeCap.butt,
          );
        }
      } else {
        canvas.drawLine(
          Offset.fromDirection(angle, radiusMinutes * 0.85),
          Offset.fromDirection(angle, radiusMinutes),
          Paint()
            ..color = Colors.white
            ..strokeWidth = 1
            ..strokeCap = StrokeCap.butt,
        );
        // Draw numbers
        TextSpan span = TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white54,
            fontWeight: FontWeight.bold,
          ),
          text:
              '${(i == 0 ? 30 : i % 5 == 0 ? (i ~/ 2).toString().padLeft(2, '0') : '')}',
        );

        TextPainter tp = TextPainter(
          text: span,
          textAlign: TextAlign.left,
          textDirection: TextDirection.ltr,
        );
        tp.layout();

        Offset offset = Offset.fromDirection(angle, radiusMinutes * 0.60);
        offset = offset.translate(-tp.width / 2, -tp.preferredLineHeight / 2);
        tp.paint(canvas, offset);
      }
    }

    /// Draws hand brush
    canvas.drawLine(
      Offset.zero,
      Offset.fromDirection(
          -((math.pi / 2) -
              (2 * math.pi / 3600) * (dateTime.minute * 60 + dateTime.second)),
          radiusMinutes),
      Paint()
        ..color = Colors.orange
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.round,
    );

    /// Draws the center smaller circle
    canvas.drawCircle(
      Offset.zero,
      radius * 0.015,
      clockPaint
        ..style = PaintingStyle.fill
        ..color = Colors.orange,
    );
    canvas.restore();
    canvas.save();

    /// Draw mini seconds clock
    final double centerSecondsX = size.width / 2;
    final double centerSecondsY = size.height / 1.7;
    final double radiusSeconds = min(centerSecondsX, centerSecondsY) * 0.25;
    canvas.translate(centerSecondsX, centerSecondsY);

    for (int i = 0; i <= 59; i++) {
      final angle = -90.radians + (i * 360 / 60).radians;

      /// Draws the tick for each angle
      if (i % 5 != 0) {
        canvas.drawLine(
          Offset.fromDirection(angle, radiusSeconds * 0.90),
          Offset.fromDirection(angle, radiusSeconds),
          Paint()
            ..color = Colors.white38
            ..strokeWidth = 1
            ..strokeCap = StrokeCap.butt,
        );
      } else {
        canvas.drawLine(
          Offset.fromDirection(angle, radiusSeconds * 0.85),
          Offset.fromDirection(angle, radiusSeconds),
          Paint()
            ..color = Colors.white
            ..strokeWidth = 1
            ..strokeCap = StrokeCap.butt,
        );
        if (i % 3 == 0) {
          // Draw numbers
          TextSpan span = TextSpan(
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white54,
              fontWeight: FontWeight.bold,
            ),
            text: '${(i == 0 ? 60 : i)}',
          );

          TextPainter tp = TextPainter(
            text: span,
            textAlign: TextAlign.left,
            textDirection: TextDirection.ltr,
          );
          tp.layout();

          Offset offset = Offset.fromDirection(angle, radiusSeconds * 0.60);
          offset = offset.translate(-tp.width / 2, -tp.preferredLineHeight / 2);
          tp.paint(canvas, offset);
        }
      }
    }

    /// Draws hand brush
    canvas.drawLine(
      Offset.zero,
      Offset.fromDirection(
          -((math.pi / 2) -
              (2 * math.pi / 60000) *
                  (dateTime.second * 1000 + dateTime.millisecond)),
          radiusSeconds),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.butt,
    );

    canvas.drawCircle(
      Offset.zero,
      radius * 0.015,
      clockPaint
        ..style = PaintingStyle.fill
        ..color = Colors.white,
    );

    canvas.restore();
    canvas.translate(centerX, centerY);

    //
    //
    // WORK IN PROGRESS END
    //
    //

    // Draws the clock hour hand
    canvas.drawLine(
      Offset.zero,
      Offset.fromDirection(
          -((math.pi / 2) -
              (2 * math.pi / 720) *
                  (dateTime.hour * 60 +
                      dateTime.minute +
                      (dateTime.second / 60))),
          radius * 0.2),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawLine(
      Offset.fromDirection(
          -((math.pi / 2) -
              (2 * math.pi / 720) *
                  (dateTime.hour * 60 +
                      dateTime.minute +
                      (dateTime.second / 60))),
          radius * 0.13),
      Offset.fromDirection(
          -((math.pi / 2) -
              (2 * math.pi / 720) *
                  (dateTime.hour * 60 +
                      dateTime.minute +
                      (dateTime.second / 60))),
          radius * 0.54),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawLine(
      Offset.fromDirection(
          -((math.pi / 2) -
              (2 * math.pi / 720) *
                  (dateTime.hour * 60 +
                      dateTime.minute +
                      (dateTime.second / 60))),
          radius * 0.13),
      Offset.fromDirection(
          -((math.pi / 2) -
              (2 * math.pi / 720) *
                  (dateTime.hour * 60 +
                      dateTime.minute +
                      (dateTime.second / 60))),
          radius * 0.54),
      Paint()
        ..color = Colors.black
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round,
    );

    // Draws the clock minutes hand
    canvas.drawLine(
      Offset.zero,
      Offset.fromDirection(
          -((math.pi / 2) -
              (2 * math.pi / 3600) * (dateTime.minute * 60 + dateTime.second)),
          radius * 0.2),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawLine(
      Offset.fromDirection(
          -((math.pi / 2) -
              (2 * math.pi / 3600) * (dateTime.minute * 60 + dateTime.second)),
          radius * 0.13),
      Offset.fromDirection(
          -((math.pi / 2) -
              (2 * math.pi / 3600) * (dateTime.minute * 60 + dateTime.second)),
          radius * 0.80),
      Paint()
        ..color = Colors.white
        ..strokeWidth = 16
        ..strokeCap = StrokeCap.round,
    );

    canvas.drawLine(
      Offset.fromDirection(
          -((math.pi / 2) -
              (2 * math.pi / 3600) * (dateTime.minute * 60 + dateTime.second)),
          radius * 0.13),
      Offset.fromDirection(
          -((math.pi / 2) -
              (2 * math.pi / 3600) * (dateTime.minute * 60 + dateTime.second)),
          radius * 0.80),
      Paint()
        ..color = Colors.black
        ..strokeWidth = 12
        ..strokeCap = StrokeCap.round,
    );

    // Draws the clock seconds hand
    canvas.drawLine(
      Offset.fromDirection(
          ((math.pi / 2) +
              (2 * math.pi / 60000) *
                  (dateTime.second * 1000 + dateTime.millisecond)),
          radius * 0.1),
      Offset.fromDirection(
          -((math.pi / 2) -
              (2 * math.pi / 60000) *
                  (dateTime.second * 1000 + dateTime.millisecond)),
          radius),
      Paint()
        ..color = Colors.orange
        ..strokeWidth = 2
        ..strokeCap = StrokeCap.butt,
    );

    /// Draws the center smaller circle
    canvas.drawCircle(
      Offset.zero,
      radius * 0.040,
      clockPaint
        ..style = PaintingStyle.fill
        ..color = Colors.grey,
    );

    /// Draws the center smaller circle
    canvas.drawCircle(
      Offset.zero,
      radius * 0.03,
      clockPaint
        ..style = PaintingStyle.fill
        ..color = Colors.orange,
    );

    /// Draws the center smaller circle
    canvas.drawCircle(
      Offset.zero,
      radius * 0.015,
      clockPaint
        ..style = PaintingStyle.fill
        ..color = Colors.black,
    );
  }

  @override
  bool shouldRepaint(AnalogClockPaintApple oldDelegate) => true;
}
