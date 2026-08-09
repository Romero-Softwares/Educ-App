import 'package:flutter/material.dart';
import 'dart:math' as math;

// Orb data
class _Orb {
  final double x;
  final double y;
  final double size;
  final double speed;
  final double phase;
  final Color color;

  const _Orb({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.phase,
    required this.color,
  });
}

const List<_Orb> _orbs = [
  _Orb(x: 0.15, y: 0.10, size: 160, speed: 1.0, phase: 0.0,  color: Color(0x30FFFFFF)),
  _Orb(x: 0.75, y: 0.22, size: 120, speed: 0.7, phase: 1.2,  color: Color(0x25FFD54F)),
  _Orb(x: 0.50, y: 0.55, size: 200, speed: 0.5, phase: 2.5,  color: Color(0x20CE93D8)),
  _Orb(x: 0.10, y: 0.70, size: 100, speed: 0.9, phase: 0.8,  color: Color(0x28A5D6A7)),
  _Orb(x: 0.85, y: 0.75, size: 140, speed: 0.6, phase: 3.1,  color: Color(0x2280DEEA)),
  _Orb(x: 0.60, y: 0.90, size: 90,  speed: 1.1, phase: 1.8,  color: Color(0x22EF9A9A)),
];

class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      duration: const Duration(seconds: 14),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // Deep purple → indigo gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4A148C), // deep purple
                  Color(0xFF1565C0), // deep blue
                  Color(0xFF006064), // teal hint
                ],
                stops: [0.0, 0.6, 1.0],
              ),
            ),
          ),

          // Floating orbs
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              return Stack(
                children: _orbs.map((orb) {
                  final t = _ctrl.value * 2 * math.pi * orb.speed + orb.phase;
                  final dx = math.sin(t) * 28;
                  final dy = math.cos(t * 0.7) * 20;
                  return Positioned(
                    left: size.width * orb.x + dx - orb.size / 2,
                    top:  size.height * orb.y + dy - orb.size / 2,
                    child: Container(
                      width: orb.size,
                      height: orb.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: orb.color,
                      ),
                    ),
                  );
                }).toList(),
              );
            },
          ),

          // Subtle star particles
          AnimatedBuilder(
            animation: _ctrl,
            builder: (_, __) {
              return CustomPaint(
                size: Size(size.width, size.height),
                painter: _StarsPainter(_ctrl.value),
              );
            },
          ),

          // Content — NOT wrapped in SafeArea here so screens can control it
          widget.child,
        ],
      ),
    );
  }
}

// Tiny twinkling stars
class _StarsPainter extends CustomPainter {
  final double t;
  _StarsPainter(this.t);

  static final List<Offset> _positions = List.generate(
    18,
    (i) => Offset(
      (i * 137.5 % 1.0) * 1.0, // normalized x
      (i * 97.3 % 1.0) * 1.0,  // normalized y
    ),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    for (int i = 0; i < _positions.length; i++) {
      final phase = i * 0.4;
      final alpha = ((math.sin(t * 2 * math.pi * 0.8 + phase) + 1) / 2 * 0.5 + 0.1).clamp(0.0, 1.0);
      paint.color = Colors.white.withOpacity(alpha);
      final radius = 1.5 + (math.sin(t * 2 * math.pi + phase) + 1);
      canvas.drawCircle(
        Offset(_positions[i].dx * size.width, _positions[i].dy * size.height),
        radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_StarsPainter old) => true;
}
