import 'package:flutter_test/flutter_test.dart';
import 'package:educapp/providers/game_provider.dart';
import 'package:educapp/utils/dictionary.dart';

void main() {
  group('GameProvider Word Selection Tests', () {
    late GameProvider gameProvider;

    setUp(() {
      gameProvider = GameProvider();
    });

    test('Should not repeat words in the same session', () {
      // 'Cores' has 3 words at difficulty 1: AZUL, ROSA, ROXO
      gameProvider.startNewGame('Cores');
      
      final usedWords = <String>{};
      final firstWord = gameProvider.currentWord!.text;
      usedWords.add(firstWord);

      // We can get 2 more unique words
      for (int i = 0; i < 2; i++) {
        gameProvider.nextWord();
        final newWord = gameProvider.currentWord!.text;
        
        expect(usedWords.contains(newWord), isFalse, 
            reason: 'Word "$newWord" was repeated before exhausting the pool.');
        
        usedWords.add(newWord);
      }
    });

    test('Should reset used words when all options are exhausted', () {
      // 'Veículos' difficulty 1 has only 2 words (MOTO, TREM)
      gameProvider.startNewGame('Veículos');
      // Force difficulty 1 selection logic by ignoring the advance logic for this test
      // Actually, _selectRandomWord uses _currentDifficulty which starts at 1
      
      final word1 = gameProvider.currentWord!.text;
      gameProvider.nextWord();
      final word2 = gameProvider.currentWord!.text;
      
      expect(word1 != word2, isTrue);

      // Now both 'MOTO' and 'TREM' (difficulty 1) are used.
      // The next call should reset the pool and pick one of them again.
      gameProvider.nextWord();
      final word3 = gameProvider.currentWord!.text;
      
      expect(word3 == word1 || word3 == word2, isTrue);
    });
  });
}
