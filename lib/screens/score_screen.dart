import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../widgets/animated_background.dart';
import '../utils/sound_service.dart';
import 'home_screen.dart';
import 'modules_screen.dart';

class ScoreScreen extends StatefulWidget {
  final GameSession session;
  final String? category;

  const ScoreScreen({super.key, required this.session, this.category});

  @override
  State<ScoreScreen> createState() => _ScoreScreenState();
}

class _ScoreScreenState extends State<ScoreScreen> {
  @override
  void initState() {
    super.initState();
    _playStarSounds();
  }

  Future<void> _playStarSounds() async {
    for (int i = 0; i < widget.session.stars; i++) {
      await Future.delayed(Duration(milliseconds: 400 + i * 350));
      if (mounted) SoundService.playStar();
    }
  }

  @override
  Widget build(BuildContext context) {
    final session = widget.session;
    final stars = session.stars;
    final accuracy = session.totalWords == 0
        ? 0
        : (session.score / session.totalWords * 100).round();

    return AnimatedBackground(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Title
            const Text(
              'Sessão Concluída!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold,
                shadows: [Shadow(color: Colors.black38, blurRadius: 6)],
              ),
            ).animate().fadeIn(duration: 500.ms).moveY(begin: -30),

             const SizedBox(height: 32),
             
                // Stars
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (i) {
                    final filled = i < stars;
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: Container(
                        width: 64,
                        height: 64,
                        decoration: BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment.topLeft,
                            radius: 0.8,
                            colors: [Colors.yellow.shade300, Colors.amber, Colors.orange.shade700],
                            stops: [0.0, 0.6, 1.0],
                          ),
                          borderRadius: BorderRadius.circular(32),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 8,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          filled ? Icons.star_rounded : Icons.star_outline_rounded,
                          size: 40,
                          color: filled ? Colors.white : Colors.white30,
                        ),
                      ).animate(delay: (500 + i * 350).ms)
                       .scale(begin: const Offset(0.3, 0.3), curve: Curves.elasticOut)
                       .fadeIn(),
                    );
                  }),
                ),

            const SizedBox(height: 36),

            // Stats card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white24),
                ),
                padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
                child: Column(
                  children: [
                    _StatRow(
                      emoji: '✅',
                      label: 'Acertos',
                      value: '${session.score} / ${session.totalWords}',
                    ),
                    const Divider(color: Colors.white24, height: 24),
                    _StatRow(
                      emoji: '🎯',
                      label: 'Precisão',
                      value: '$accuracy%',
                    ),
                    const Divider(color: Colors.white24, height: 24),
                    _StatRow(
                      emoji: '🔥',
                      label: 'Maior Sequência',
                      value: '${session.maxStreak}',
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 400.ms).scale(curve: Curves.easeOut),
            ),

            const SizedBox(height: 40),

            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _ActionButton(
                  label: 'JOGAR DE NOVO',
                  icon: Icons.replay,
                  color: const Color(0xFF43A047),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ModulesScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 16),
                _ActionButton(
                  label: 'INÍCIO',
                  icon: Icons.home,
                  color: Colors.white24,
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (_) => const HomeScreen()),
                      (_) => false,
                    );
                  },
                ),
              ],
            ).animate().fadeIn(delay: 800.ms).moveY(begin: 30),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _StatRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _StatRow({required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 10),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 17)),
          ],
        ),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ActionButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(color: Colors.white30),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 3))],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1)),
          ],
        ),
      ),
    );
  }
}
