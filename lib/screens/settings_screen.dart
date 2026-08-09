import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../providers/game_provider.dart';
import '../providers/player_provider.dart';
import '../widgets/animated_background.dart';
import '../utils/sound_service.dart';
import 'home_screen.dart';

class SettingsScreen extends StatefulWidget {
  final bool isInitial;
  const SettingsScreen({super.key, this.isInitial = false});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final player = Provider.of<PlayerProvider>(context, listen: false).player;
    if (player != null) _nameController.text = player.name;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pp = Provider.of<PlayerProvider>(context);

    return AnimatedBackground(
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Back button if not initial
              if (!widget.isInitial)
                Align(
                  alignment: Alignment.topLeft,
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),

              // Title
              Text(
                widget.isInitial
                    ? '👋 Bem-vindo!\nComo posso te chamar?'
                    : '⚙️ Configurações',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  height: 1.3,
                ),
              ).animate().fadeIn(duration: 500.ms).moveY(begin: -20),

              const SizedBox(height: 40),

              // Name field
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white38),
                ),
                child: TextField(
                  controller: _nameController,
                  style: const TextStyle(color: Colors.white, fontSize: 18),
                  decoration: InputDecoration(
                    hintText: 'Seu nome...',
                    hintStyle: const TextStyle(color: Colors.white54),
                    prefixIcon: const Icon(Icons.person_outline, color: Colors.white70),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  ),
                ),
              ).animate().fadeIn(delay: 200.ms),

              const SizedBox(height: 24),

              // Save button
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF43A047),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text('SALVAR',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: 1.5)),
              ).animate().fadeIn(delay: 350.ms),

              // Sound toggle (only on non-initial settings)
              if (!widget.isInitial) ...[
                const SizedBox(height: 32),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: SwitchListTile(
                    title: const Text('Sons do jogo',
                        style: TextStyle(color: Colors.white, fontSize: 17)),
                    subtitle: Text(
                      pp.isSoundEnabled ? 'Ativado' : 'Desativado',
                      style: const TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                    secondary: Icon(
                      pp.isSoundEnabled ? Icons.volume_up : Icons.volume_off,
                      color: Colors.white70,
                    ),
                    value: pp.isSoundEnabled,
                    onChanged: (_) => pp.toggleSound(),
                    activeColor: Colors.amber,
                  ),
                ).animate().fadeIn(delay: 450.ms),
                
                const SizedBox(height: 24),
                
                // Game Mode selector
                Text(
                  'Modo de Jogo',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ).animate().fadeIn(delay: 550.ms),
                
                const SizedBox(height: 12),
                
                Consumer<GameProvider>(
                  builder: (ctx, game, _) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<GameMode>(
                          title: const Text('Desafio', style: TextStyle(color: Colors.white)),
                          subtitle: const Text('As letras ficam embaralhadas', style: TextStyle(color: Colors.white60, fontSize: 12)),
                          value: GameMode.scrambled,
                          groupValue: game.gameMode,
                          activeColor: Colors.amber,
                          onChanged: (mode) {
                            if (mode != null) game.setGameMode(mode);
                          },
                        ),
                        Divider(color: Colors.white12, height: 1),
                        RadioListTile<GameMode>(
                          title: const Text('Aprendizado (Cópia)', style: TextStyle(color: Colors.white)),
                          subtitle: const Text('A palavra aparece para ser copiada', style: TextStyle(color: Colors.white60, fontSize: 12)),
                          value: GameMode.copy,
                          groupValue: game.gameMode,
                          activeColor: Colors.amber,
                          onChanged: (mode) {
                            if (mode != null) game.setGameMode(mode);
                          },
                        ),
                      ],
                    ),
                  ),
                ).animate().fadeIn(delay: 600.ms),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _save() {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;
    SoundService.playClick();
    Provider.of<PlayerProvider>(context, listen: false).savePlayer(name);
    if (widget.isInitial) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomeScreen()),
      );
    } else {
      Navigator.pop(context);
    }
  }
}
