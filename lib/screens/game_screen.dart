import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/animated_background.dart';
import '../utils/sound_service.dart';
import '../utils/dictionary.dart';
import 'score_screen.dart';

class GameScreen extends StatefulWidget {
  final String? category;
  const GameScreen({super.key, this.category});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late AnimationController _shakeController;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<GameProvider>(context, listen: false)
          .startNewGame(widget.category);
    });
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final game   = Provider.of<GameProvider>(context);
    final player = Provider.of<PlayerProvider>(context, listen: false);
    final moduleInfo = widget.category != null
        ? Dictionary.getModuleInfo(widget.category!)
        : null;
    final themeColor = moduleInfo?.color ?? const Color(0xFF6A1B9A);

    if (game.currentWord == null) {
      return Scaffold(
        backgroundColor: themeColor,
        body: const Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }

    return AnimatedBackground(
      child: SafeArea(
        child: Column(
          children: [
            _buildHeader(context, game, moduleInfo, themeColor),
            _buildProgressBar(game),
            const SizedBox(height: 8),
            _buildStreakBadge(game),
            const Spacer(),
            _buildWordDisplay(game),
            const SizedBox(height: 32),
            _buildLettersGrid(game, player),
            const Spacer(),
            _buildControls(game),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  // ── Header ─────────────────────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context, GameProvider game,
      ModuleInfo? module, Color themeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white, size: 28),
            onPressed: () => Navigator.pop(context),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  module != null
                      ? '${module.emoji}  ${module.name}'
                      : '🎲  Modo Livre',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Nível ${game.currentDifficulty}',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),
          // Score chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 18),
                const SizedBox(width: 4),
                Text(
                  '${game.sessionScore}',
                  style: const TextStyle(
                      color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Progress bar ───────────────────────────────────────────────────────────

  Widget _buildProgressBar(GameProvider game) {
    final progress = (game.wordsAttempted / game.sessionLength).clamp(0.0, 1.0);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${game.wordsAttempted}/${game.sessionLength}',
            style: const TextStyle(color: Colors.white70, fontSize: 11),
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: Colors.white24,
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.amber),
            ),
          ),
        ],
      ),
    );
  }

  // ── Streak badge ───────────────────────────────────────────────────────────

  Widget _buildStreakBadge(GameProvider game) {
    if (game.streak < 2) return const SizedBox(height: 8);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.85),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
      ),
      child: Text(
        '🔥 ${game.streak} em sequência!',
        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
      ),
    ).animate().scale(curve: Curves.easeOutBack);
  }

  // ── Word display ───────────────────────────────────────────────────────────

  Widget _buildWordDisplay(GameProvider game) {
    final word = game.currentWord!.text;
    return Column(
      children: [
        Text(
          game.gameMode == GameMode.copy ? 'Copie a palavra:' : 'Monte a palavra:',
          style: TextStyle(color: Colors.white70, fontSize: 18),
        ),
        if (game.gameMode == GameMode.copy) ...[
          const SizedBox(height: 8),
          Text(
            word.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 36,
              fontWeight: FontWeight.w900,
              letterSpacing: 8,
              shadows: [Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 3))],
            ),
          ).animate().fadeIn().scale(curve: Curves.easeOutBack),
        ],
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 6,
          children: List.generate(word.length, (i) {
            final hasLetter = i < game.selectedLetters.length;
            final letter = hasLetter ? game.selectedLetters[i] : '';
            final isWrong = game.status == GameStatus.wrong && hasLetter;
            return GestureDetector(
              onTap: hasLetter ? () {
                SoundService.playClick();
                game.undoLetter();
              } : null,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: word.length > 7 ? 40 : 48,
                height: word.length > 7 ? 50 : 58,
                decoration: BoxDecoration(
                  color: isWrong
                      ? Colors.red.shade100
                      : hasLetter
                          ? Colors.white
                          : Colors.white24,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: hasLetter ? Colors.white : Colors.white38,
                    width: 2,
                  ),
                  boxShadow: hasLetter
                      ? const [BoxShadow(color: Colors.black26, blurRadius: 4)]
                      : [],
                ),
                child: Center(
                  child: Text(
                    letter,
                    style: TextStyle(
                      fontSize: word.length > 7 ? 22 : 26,
                      fontWeight: FontWeight.bold,
                      color: isWrong ? Colors.red : Colors.deepPurple,
                    ),
                  ),
                ),
              ).animate(target: hasLetter ? 1 : 0).scale(duration: 180.ms),
            );
          }),
        ),
        const SizedBox(height: 8),
        const Text(
          'Toque em uma letra para desfazer',
          style: TextStyle(color: Colors.white38, fontSize: 11),
        ),
      ],
    );
  }

  // ── Letters grid ───────────────────────────────────────────────────────────

  Widget _buildLettersGrid(GameProvider game, PlayerProvider player) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        alignment: WrapAlignment.center,
        children: List.generate(game.scrambledLetters.length, (i) {
          final letter = game.scrambledLetters[i];
          if (letter.isEmpty) {
            return const SizedBox(width: 58, height: 58);
          }

          Widget btn = GestureDetector(
            onTap: () async {
              SoundService.playClick();
              final correct = game.addLetter(letter, i);
              if (correct) {
                await SoundService.playCorrect();
                player.updateScore(1);
                if (game.isSessionOver) {
                  if (context.mounted) _goToScoreScreen(game, player);
                } else {
                  if (context.mounted) _showWordCorrectDialog(game);
                }
              } else if (game.status == GameStatus.wrong) {
                SoundService.playWrong();
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: game.status == GameStatus.wrong
                      ? [Colors.red.shade400, Colors.red.shade700]
                      : [Colors.orangeAccent, const Color(0xFFF57C00)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: game.status == GameStatus.wrong
                        ? Colors.red.withOpacity(0.5)
                        : Colors.orange.withOpacity(0.5),
                    offset: const Offset(0, 4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  letter,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [Shadow(color: Colors.black26, blurRadius: 3)],
                  ),
                ),
              ),
            ),
          );

          if (game.status == GameStatus.wrong) {
            btn = btn.animate().shake(hz: 5, duration: 500.ms);
          }

          return btn
              .animate()
              .scale(delay: (i * 40).ms, curve: Curves.easeOutBack);
        }),
      ),
    );
  }

  // ── Controls ───────────────────────────────────────────────────────────────

  Widget _buildControls(GameProvider game) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _ControlButton(
          icon: Icons.refresh,
          label: 'Reiniciar',
          color: Colors.white24,
          onTap: () {
            SoundService.playClick();
            game.resetWord();
          },
        ),
        const SizedBox(width: 24),
        _ControlButton(
          icon: Icons.skip_next,
          label: 'Pular',
          color: Colors.white24,
          onTap: () {
            SoundService.playClick();
            game.nextWord();
          },
        ),
      ],
    );
  }

  // ── Dialogs ────────────────────────────────────────────────────────────────

   void _showWordCorrectDialog(GameProvider game) {
     showDialog(
       context: context,
       barrierDismissible: false,
       builder: (_) => Dialog(
         backgroundColor: Colors.transparent,
         child: Container(
           padding: const EdgeInsets.all(28),
           decoration: BoxDecoration(
             gradient: const LinearGradient(
               colors: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
               begin: Alignment.topLeft,
               end: Alignment.bottomRight,
             ),
             borderRadius: BorderRadius.circular(28),
             boxShadow: const [BoxShadow(color: Colors.black38, blurRadius: 20)],
           ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                 Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(
                        center: Alignment.topLeft,
                        radius: 0.8,
                        colors: [Colors.yellow.shade300, Colors.amber, Colors.orange.shade700],
                        stops: [0.0, 0.6, 1.0],
                      ),
                      borderRadius: BorderRadius.circular(40),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 12,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                   child: const Icon(
                     Icons.star,
                     size: 50,
                     color: Colors.white,
                   ),
                 )
                    .animate()
                    .scale(duration: 500.ms, curve: Curves.elasticOut)
                    .then()
                    .shake(hz: 2),
              const SizedBox(height: 12),
              const Text(
                'MUITO BEM!',
                style: TextStyle(
                    color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text('+1 ponto', style: TextStyle(color: Colors.white70, fontSize: 20)),
              if (game.streak >= 2)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    '🔥 Sequência de ${game.streak}!',
                    style: const TextStyle(color: Colors.amber, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  game.nextWord();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.green.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('PRÓXIMA →',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _goToScoreScreen(GameProvider game, PlayerProvider player) {
    final session = game.getSessionResult();
    SoundService.playLevelUp();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => ScoreScreen(
          session: session,
          category: widget.category,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────

class _ControlButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ControlButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white30),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 22),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.white, fontSize: 14)),
          ],
        ),
      ),
    );
  }
}
