import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const EmojiDrawApp());
}

class EmojiDrawApp extends StatelessWidget {
  const EmojiDrawApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Emoji Painter',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.amber),
      home: const EmojiHome(),
    );
  }
}

enum EmojiType { party, heart, smile }

class EmojiHome extends StatefulWidget {
  const EmojiHome({super.key});

  @override
  State<EmojiHome> createState() => _EmojiHomeState();
}

class _EmojiHomeState extends State<EmojiHome> {
  EmojiType selected = EmojiType.party;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFE082), Color(0xFF80DEEA)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Interactive Emoji Drawing'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Simple selection row (beginner-friendly widgets)
              Row(
                children: [
                  const Text('Choose emoji:'),
                  const SizedBox(width: 12),
                  DropdownButton<EmojiType>(
                    value: selected,
                    items: const [
                      DropdownMenuItem(
                        value: EmojiType.party,
                        child: Text('Party Face'),
                      ),
                      DropdownMenuItem(
                        value: EmojiType.heart,
                        child: Text('Heart'),
                      ),
                      DropdownMenuItem(
                        value: EmojiType.smile,
                        child: Text('Smiley'),
                      ),
                    ],
                    onChanged: (v) => setState(() => selected = v ?? selected),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Drawing area
              Expanded(
                child: RepaintBoundary(
                  child: CustomPaint(
                    painter: EmojiPainter(selected: selected),
                    child: const SizedBox.expand(),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Tiny legend to show we used basic shapes (Task 1)
              const Text(
                'Built with circles, rectangles, arcs, and paths using CustomPainter.',
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class EmojiPainter extends CustomPainter {
  final EmojiType selected;
  const EmojiPainter({required this.selected});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final s = 140.0; // fixed size per assignment (no size control)

    switch (selected) {
      case EmojiType.party:
        _drawPartyFace(canvas, center, s);
        break;
      case EmojiType.heart:
        _drawHeart(canvas, center, s * 0.95);
        break;
      case EmojiType.smile:
        _drawSmiley(canvas, center, s);
        break;
    }
  }

  // === Party Face ===
  void _drawPartyFace(Canvas canvas, Offset c, double s) {
    // Face circle
    final facePaint = Paint()..color = const Color(0xFFFFEB3B);
    canvas.drawCircle(c, s * 0.7, facePaint);

    // Eyes
    final eyePaint = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(c.dx - s * 0.25, c.dy - s * 0.15), s * 0.07, eyePaint);
    canvas.drawCircle(Offset(c.dx + s * 0.25, c.dy - s * 0.10), s * 0.07, eyePaint);

    // Winking detail (small line on left)
    final wink = Paint()
      ..color = Colors.black
      ..strokeWidth = s * 0.03
      ..style = PaintingStyle.stroke;
    canvas.drawLine(
      Offset(c.dx - s * 0.33, c.dy - s * 0.25),
      Offset(c.dx - s * 0.17, c.dy - s * 0.20),
      wink,
    );

    // Smile arc (bigger, bright)
    final smilePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.08
      ..strokeCap = StrokeCap.round
      ..shader = const SweepGradient(
        colors: [Colors.deepOrange, Colors.pink, Colors.purple],
      ).createShader(Rect.fromCircle(center: c, radius: s * 0.7));

    final smileRect = Rect.fromCircle(center: Offset(c.dx, c.dy + s * 0.05), radius: s * 0.45);
    canvas.drawArc(smileRect, pi * 0.15, pi * 0.7, false, smilePaint);

    // Party hat (simple triangle)
    final hat = Path()
      ..moveTo(c.dx, c.dy - s * 0.85)
      ..lineTo(c.dx - s * 0.45, c.dy - s * 0.25)
      ..lineTo(c.dx + s * 0.20, c.dy - s * 0.25)
      ..close();

    final hatPaint = Paint()..shader = const LinearGradient(colors: [Colors.blue, Colors.cyan]).createShader(
        Rect.fromCircle(center: Offset(c.dx, c.dy - s * 0.6), radius: s * 0.5));
    canvas.drawPath(hat, hatPaint);

    // Hat stripe
    final stripe = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.04;
    canvas.drawLine(
      Offset(c.dx - s * 0.35, c.dy - s * 0.45),
      Offset(c.dx + s * 0.05, c.dy - s * 0.45),
      stripe,
    );

    // Confetti (different simple shapes)
    final rnd = Random(7); // fixed seed = consistent output
    for (int i = 0; i < 22; i++) {
      final dx = c.dx + (rnd.nextDouble() * 2 - 1) * s * 0.95;
      final dy = c.dy + (rnd.nextDouble() * 2 - 1) * s * 0.95;
      final p = Paint()
        ..color = Colors.primaries[i % Colors.primaries.length]
        ..style = PaintingStyle.fill;
      final choice = i % 3;
      final r = s * 0.04;
      if (choice == 0) {
        canvas.drawCircle(Offset(dx, dy), r * 0.6, p);
      } else if (choice == 1) {
        canvas.drawRect(Rect.fromCenter(center: Offset(dx, dy), width: r, height: r), p);
      } else {
        final path = Path()
          ..moveTo(dx, dy - r)
          ..lineTo(dx - r * 0.7, dy + r * 0.6)
          ..lineTo(dx + r * 0.7, dy + r * 0.6)
          ..close();
        canvas.drawPath(path, p);
      }
    }
  }

  // === Heart ===
  void _drawHeart(Canvas canvas, Offset c, double s) {
    final heart = Path();
    final top = s * 0.6;
    // Simple bezier heart (beginner-friendly numbers)
    heart.moveTo(c.dx, c.dy + s * 0.35);
    heart.cubicTo(
      c.dx + s * 0.55, c.dy + s * 0.00,
      c.dx + s * 0.45, c.dy - top,
      c.dx, c.dy - s * 0.25,
    );
    heart.cubicTo(
      c.dx - s * 0.45, c.dy - top,
      c.dx - s * 0.55, c.dy + s * 0.00,
      c.dx, c.dy + s * 0.35,
    );

    final fill = Paint()
      ..shader = const LinearGradient(
        colors: [Color(0xFFFF6E7F), Color(0xFFFFA07A)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromCircle(center: c, radius: s));
    canvas.drawPath(heart, fill);

    final border = Paint()
      ..color = Colors.red.shade900
      ..style = PaintingStyle.stroke
      ..strokeWidth = s * 0.04;
    canvas.drawPath(heart, border);
  }

  // === Classic Smiley (big bright smile) ===
  void _drawSmiley(Canvas canvas, Offset c, double s) {
    // Face
    final face = Paint()..color = const Color(0xFFFFF176);
    canvas.drawCircle(c, s * 0.7, face);

    // Eyes
    final black = Paint()..color = Colors.black;
    canvas.drawCircle(Offset(c.dx - s * 0.22, c.dy - s * 0.18), s * 0.08, black);
    canvas.drawCircle(Offset(c.dx + s * 0.22, c.dy - s * 0.18), s * 0.08, black);

    // Mouth background (white teeth strip)
    final mouthRect = Rect.fromCenter(center: Offset(c.dx, c.dy + s * 0.18), width: s * 0.9, height: s * 0.5);
    final mouthClip = Path()
      ..addArc(mouthRect, pi * 0.15, pi * 0.7);
    canvas.drawPath(
      mouthClip,
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.18
        ..strokeCap = StrokeCap.round,
    );

    // Lip color on top of white to make it bright
    canvas.drawArc(
      mouthRect,
      pi * 0.15,
      pi * 0.7,
      false,
      Paint()
        ..color = Colors.redAccent
        ..style = PaintingStyle.stroke
        ..strokeWidth = s * 0.10
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant EmojiPainter oldDelegate) {
    return oldDelegate.selected != selected;
  }
}