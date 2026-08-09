import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../utils/dictionary.dart';
import '../widgets/animated_background.dart';
import 'game_screen.dart';

class ModulesScreen extends StatelessWidget {
  const ModulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 12, 8, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white, size: 26),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Expanded(
                    child: Text(
                      'Escolha um Módulo',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 4)],
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).moveY(begin: -20),

            const SizedBox(height: 8),

            // "Todas as Palavras" card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: _AllWordsCard(onTap: () => _openGame(context, null)),
            ).animate().fadeIn(delay: 100.ms).scale(curve: Curves.easeOutBack),

            // Module grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  childAspectRatio: 1.15,
                ),
                itemCount: Dictionary.modules.length,
                itemBuilder: (ctx, i) {
                  final module = Dictionary.modules[i];
                  final wordCount = Dictionary.getWordsByCategory(module.name).length;
                  return _ModuleCard(
                    module: module,
                    wordCount: wordCount,
                    onTap: () => _openGame(context, module.name),
                  ).animate().fadeIn(delay: (120 + i * 60).ms)
                   .scale(curve: Curves.easeOutBack, delay: (120 + i * 60).ms);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openGame(BuildContext context, String? category) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => GameScreen(category: category)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _AllWordsCard extends StatelessWidget {
  final VoidCallback onTap;
  const _AllWordsCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 70,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFF1565C0)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎲', style: TextStyle(fontSize: 30)),
            const SizedBox(width: 12),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('MODO LIVRE', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
                Text(
                  '${Dictionary.words.length} palavras de todas as categorias',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
            const SizedBox(width: 12),
            const Icon(Icons.chevron_right, color: Colors.white70, size: 28),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ModuleCard extends StatelessWidget {
  final ModuleInfo module;
  final int wordCount;
  final VoidCallback onTap;

  const _ModuleCard({
    required this.module,
    required this.wordCount,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [module.color, module.darkColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: module.darkColor.withOpacity(0.5),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background emoji watermark
            Positioned(
              right: -10,
              bottom: -8,
              child: Text(module.emoji, style: const TextStyle(fontSize: 72, height: 1)),
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(module.emoji, style: const TextStyle(fontSize: 34)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        module.name.toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1,
                        ),
                      ),
                      Text(
                        '$wordCount palavras',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
