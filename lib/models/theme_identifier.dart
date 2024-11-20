/// Identifies different card themes in the game
class ThemeIdentifier {
  final String id;
  final String name;

  const ThemeIdentifier._(this.id, this.name);

  // Predefined theme identifiers
  static const classic = ThemeIdentifier._('classic', 'Classic');
  static const geometry = ThemeIdentifier._('geometry', 'Geometry');
  static const nature = ThemeIdentifier._('nature', 'Nature');
  static const space = ThemeIdentifier._('space', 'Space');
  static const tech = ThemeIdentifier._('tech', 'Tech');

  static const List<ThemeIdentifier> values = [
    classic,
    geometry,
    nature,
    space,
    tech,
  ];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ThemeIdentifier &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}
