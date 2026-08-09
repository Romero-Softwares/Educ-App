class Word {
  final String text;
  final String category;
  final int difficulty; // 1: Easy (3-4 letters), 2: Medium (5-6 letters), 3: Hard (7+ letters)

  Word({
    required this.text,
    required this.category,
    required this.difficulty,
  });

  String get scrambledText {
    List<String> letters = text.toUpperCase().split('');
    letters.shuffle();
    return letters.join();
  }
}
