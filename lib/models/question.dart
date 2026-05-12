class Question {
  final String id;
  final String text;
  final String correctOptionID;
  final int points;
  final List<Option> options;

  Question({
    required this.id,
    required this.text,
    required this.correctOptionID,
    this.points = 1,
    required this.options,
  });

  factory Question.fromMap(Map<String, dynamic> map) {
    return Question(
      id: map['id'] ?? '',
      text: map['text'] ?? '',
      correctOptionID: map['correctOptionID'] ?? '',
      points: map['points'] ?? 1,
      options: (map['options'] as List<dynamic>)
          .map((o) => Option.fromMap(o))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'text': text,
      'correctOptionID': correctOptionID,
      'points': points,
      'options': options.map((o) => o.toMap()).toList(),
    };
  }
}

class Option {
  final String id;
  final String text;

  Option({required this.id, required this.text});

  factory Option.fromMap(Map<String, dynamic> map) {
    return Option(id: map['id'] ?? '', text: map['text'] ?? '');
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'text': text};
  }
}
