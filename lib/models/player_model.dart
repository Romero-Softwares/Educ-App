class Player {
  final String name;
  final int score;
  final String avatar;
  final Map<String, int> moduleProgress;

  Player({
    required this.name,
    this.score = 0,
    this.avatar = 'assets/images/default_avatar.png',
    this.moduleProgress = const {},
  });

  Player copyWith({
    String? name,
    int? score,
    String? avatar,
    Map<String, int>? moduleProgress,
  }) {
    return Player(
      name: name ?? this.name,
      score: score ?? this.score,
      avatar: avatar ?? this.avatar,
      moduleProgress: moduleProgress ?? this.moduleProgress,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'score': score,
      'avatar': avatar,
      'moduleProgress': moduleProgress,
    };
  }

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      name: json['name'] ?? 'Pequeno Explorador',
      score: json['score'] ?? 0,
      avatar: json['avatar'] ?? 'assets/images/default_avatar.png',
      moduleProgress: Map<String, int>.from(json['moduleProgress'] ?? {}),
    );
  }
}
