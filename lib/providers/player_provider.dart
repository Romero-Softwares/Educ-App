import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player_model.dart';
import '../utils/sound_service.dart';

class PlayerProvider with ChangeNotifier {
  Player? _player;
  bool _isSoundEnabled = true;
  bool _isLoaded = false;

  Player? get player => _player;
  bool get isSoundEnabled => _isSoundEnabled;
  bool get isLoaded => _isLoaded;

  PlayerProvider() {
    loadPlayerData();
  }

  Future<void> loadPlayerData() async {
    final prefs = await SharedPreferences.getInstance();
    final playerData = prefs.getString('player_info');
    _isSoundEnabled = prefs.getBool('sound_enabled') ?? true;
    SoundService.setEnabled(_isSoundEnabled);

    if (playerData != null) {
      try {
        final decoded = jsonDecode(playerData) as Map<String, dynamic>;
        _player = Player.fromJson(decoded);
      } catch (_) {
        await prefs.remove('player_info');
        _player = null;
      }
    }

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> savePlayer(String name) async {
    final trimmedName = name.trim();
    if (trimmedName.isEmpty) return;

    _player = Player(name: trimmedName);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_info', jsonEncode(_player!.toJson()));
    notifyListeners();
  }

  Future<void> updateScore(int points) async {
    if (_player == null || points == 0) return;

    _player = _player!.copyWith(score: _player!.score + points);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('player_info', jsonEncode(_player!.toJson()));
    notifyListeners();
  }

  Future<void> toggleSound() async {
    _isSoundEnabled = !_isSoundEnabled;
    SoundService.setEnabled(_isSoundEnabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('sound_enabled', _isSoundEnabled);
    notifyListeners();
  }
}
