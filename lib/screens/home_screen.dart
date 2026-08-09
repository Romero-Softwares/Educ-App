import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/player_provider.dart';
import '../widgets/animated_background.dart';
import '../utils/sound_service.dart';
import 'modules_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerProvider = Provider.of<PlayerProvider>(context);
    final player = playerProvider.player;

    return AnimatedBackground(
      child: SafeArea(
        child: Column(
          children: [
            // Top bar — sound toggle
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 8, right: 12),
                child: Consumer<PlayerProvider>(
                  builder: (_, pp, __) => IconButton(
                    icon: Icon(
                      pp.isSoundEnabled ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white70,
                      size: 28,
                    ),
                    onPressed: () => pp.toggleSound(),
                  ),
                ),
              ),
            ),

            const Spacer(),

            // Title
            const Text(
              'Palavra Viva 🌟',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black26, offset: Offset(2, 3), blurRadius: 6)],
              ),
            ).animate().fadeIn(duration: 600.ms).moveY(begin: -40, end: 0),

            const SizedBox(height: 8),

            Text(
              'Olá, ${player?.name ?? "Amiguinho"}! 👋',
              style: const TextStyle(fontSize: 22, color: Colors.white70),
            ).animate().fadeIn(delay: 300.ms),

            const SizedBox(height: 32),

            // Score badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white30),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, color: Colors.amber, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    '${player?.score ?? 0} pontos no total',
                    style: const TextStyle(
                        color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ).animate().fadeIn(delay: 500.ms).scale(curve: Curves.easeOut),

            const SizedBox(height: 48),

            // Play button
            _BigButton(
              text: '▶  JOGAR',
              gradient: const LinearGradient(
                  colors: [Color(0xFF43A047), Color(0xFF1B5E20)]),
              onTap: () {
                SoundService.playClick();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ModulesScreen()),
                );
              },
            ).animate().scale(delay: 500.ms, curve: Curves.easeOutBack),

            const SizedBox(height: 18),

            // Settings button
            _BigButton(
              text: '⚙  CONFIGURAÇÕES',
              gradient: const LinearGradient(
                  colors: [Color(0xFFE65100), Color(0xFFBF360C)]),
              onTap: () {
                SoundService.playClick();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
            ).animate().scale(delay: 650.ms, curve: Curves.easeOutBack),

            const Spacer(),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _BigButton extends StatelessWidget {
  final String text;
  final LinearGradient gradient;
  final VoidCallback onTap;

  const _BigButton({
    required this.text,
    required this.gradient,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(32),
          boxShadow: const [
            BoxShadow(color: Colors.black38, offset: Offset(0, 5), blurRadius: 12)
          ],
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
      ),
    );
  }
}
