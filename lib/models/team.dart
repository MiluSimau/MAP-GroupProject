class Team {
  final String name;
  final String logoUrl;

  Team({required this.name, required this.logoUrl});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'logoUrl': logoUrl,
    };
  }

factory Team.fromMap(Map<String, dynamic> map) {
  return Team(
    name: map['name'] ?? 'Unnamed Team',
    logoUrl: map.containsKey('logoUrl') && map['logoUrl'] != null
        ? map['logoUrl']
        : '', // use empty string to handle missing logoUrl
  );
}
}