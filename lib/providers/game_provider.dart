import 'dart:math';
import 'package:flutter/material.dart';
import '../models/word_model.dart';
import '../utils/dictionary.dart';

enum GameStatus { idle, playing, correct, wrong }

enum GameMode { scrambled, copy }

class GameSession {
  final int score;
  final int totalWords;
  final int streak;
  final int maxStreak;

  const GameSession({
    required this.score,
    required this.totalWords,
    required this.streak,
    required this.maxStreak,
  });

  int get stars {
    final accuracy = totalWords == 0 ? 0 : score / totalWords;
    if (accuracy >= 0.9) return 3;
    if (accuracy >= 0.6) return 2;
    if (accuracy > 0) return 1;
    return 0;
  }
}

class GameProvider with ChangeNotifier {
  Word? _currentWord;
  List<String> _scrambledLetters = [];
  List<String> _selectedLetters = [];
  String? _currentCategory;
  GameStatus _status = GameStatus.idle;
  final List<String> _usedWords = []; // Track words shown in current session
  GameMode _gameMode = GameMode.scrambled;

  // Session state
  int _sessionScore = 0;
  int _wordsAttempted = 0;
  int _streak = 0;
  int _maxStreak = 0;
  int _currentDifficulty = 1;
  int _correctAtCurrentDifficulty = 0;
  static const int _wordsPerDifficulty = 4; // advance after 4 correct
  static const int _sessionLength = 12;     // end session after 12 words

  // Getters
  Word? get currentWord => _currentWord;
  List<String> get scrambledLetters => _scrambledLetters;
  List<String> get selectedLetters => _selectedLetters;
  String? get currentCategory => _currentCategory;
  GameStatus get status => _status;
  int get sessionScore => _sessionScore;
  int get wordsAttempted => _wordsAttempted;
  int get streak => _streak;
  int get currentDifficulty => _currentDifficulty;
  int get sessionLength => _sessionLength;
  bool get isSessionOver => _wordsAttempted >= _sessionLength;
  GameMode get gameMode => _gameMode;

  void setGameMode(GameMode mode) {
    _gameMode = mode;
    notifyListeners();
  }

  void startNewGame(String? category) {
    _currentCategory = category;
    _status = GameStatus.playing;
    _sessionScore = 0;
    _wordsAttempted = 0;
    _streak = 0;
    _maxStreak = 0;
    _currentDifficulty = 1;
    _correctAtCurrentDifficulty = 0;
    _usedWords.clear();
    _selectRandomWord();
  }

  void _selectRandomWord() {
    List<Word> pool;
    if (_currentCategory == null) {
      pool = Dictionary.getWordsByDifficulty(_currentDifficulty);
    } else {
      pool = Dictionary.getWordsByCategoryAndDifficulty(
          _currentCategory!, _currentDifficulty);
    }

    // fallback: if no words at this difficulty, use all from category
    if (pool.isEmpty) {
      pool = _currentCategory == null
          ? Dictionary.words
          : Dictionary.getWordsByCategory(_currentCategory!);
    }

    // Filter out words already used in this session
    var filteredPool =
        pool.where((w) => !_usedWords.contains(w.text)).toList();

    // If all words in the current pool have been used, reset tracking for this specific pool
    // so we can start over rather than having an empty screen or error.
    if (filteredPool.isEmpty && pool.isNotEmpty) {
      _usedWords.removeWhere((wordText) => pool.any((w) => w.text == wordText));
      filteredPool = pool;
    }

    if (filteredPool.isEmpty) {
      // Last resort fallback to any word if somehow everything is exhausted
      filteredPool = Dictionary.words;
    }

    _currentWord = filteredPool[Random().nextInt(filteredPool.length)];
    _usedWords.add(_currentWord!.text);

    _scrambledLetters = _currentWord!.text.toUpperCase().split('')..shuffle();
    _selectedLetters = [];
    notifyListeners();
  }

  /// Add a letter from the scrambled grid. Returns true if the full word is correct.
  bool addLetter(String letter, int index) {
    _selectedLetters.add(letter);
    _scrambledLetters[index] = '';
    final correct = _checkWord();
    notifyListeners();
    return correct;
  }

  /// Remove the last placed letter and restore it to scrambled grid.
  void undoLetter() {
    if (_selectedLetters.isEmpty) return;
    final removed = _selectedLetters.removeLast();
    // Find first empty slot and put it back
    for (int i = 0; i < _scrambledLetters.length; i++) {
      if (_scrambledLetters[i].isEmpty) {
        _scrambledLetters[i] = removed;
        break;
      }
    }
    _status = GameStatus.playing;
    notifyListeners();
  }

  void resetWord() {
    if (_currentWord == null) return;
    _scrambledLetters = _currentWord!.text.toUpperCase().split('')..shuffle();
    _selectedLetters = [];
    _status = GameStatus.playing;
    notifyListeners();
  }

  void nextWord() {
    _status = GameStatus.playing;
    _selectRandomWord();
  }

  bool _checkWord() {
    if (_selectedLetters.length < _currentWord!.text.length) return false;

    final typed = _selectedLetters.join();
    if (typed == _currentWord!.text.toUpperCase()) {
      _sessionScore++;
      _wordsAttempted++;
      _streak++;
      if (_streak > _maxStreak) _maxStreak = _streak;
      _correctAtCurrentDifficulty++;

      // Advance difficulty every N correct answers (max difficulty 3)
      if (_correctAtCurrentDifficulty >= _wordsPerDifficulty &&
          _currentDifficulty < 3) {
        _currentDifficulty++;
        _correctAtCurrentDifficulty = 0;
      }

      _status = GameStatus.correct;
      notifyListeners();
      return true;
    } else {
      _wordsAttempted++;
      _streak = 0;
      _status = GameStatus.wrong;
      notifyListeners();
      Future.delayed(const Duration(milliseconds: 900), () {
        resetWord();
      });
      return false;
    }
  }

  GameSession getSessionResult() {
    return GameSession(
      score: _sessionScore,
      totalWords: _wordsAttempted,
      streak: _streak,
      maxStreak: _maxStreak,
    );
  }
}
