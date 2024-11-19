class MemoryCard {
  final int id;
  final String emoji;
  bool isFlipped;
  bool isMatched;

  MemoryCard({
    required this.id,
    required this.emoji,
    this.isFlipped = false,
    this.isMatched = false,
  });

  MemoryCard copyWith({
    int? id,
    String? emoji,
    bool? isFlipped,
    bool? isMatched,
  }) {
    return MemoryCard(
      id: id ?? this.id,
      emoji: emoji ?? this.emoji,
      isFlipped: isFlipped ?? this.isFlipped,
      isMatched: isMatched ?? this.isMatched,
    );
  }
}
