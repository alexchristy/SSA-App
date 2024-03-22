class TerminalSearchResult {
  final String name;
  final String location;
  final String group;
  final String timezone;

  TerminalSearchResult({
    required this.name,
    required this.location,
    required this.group,
    required this.timezone,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TerminalSearchResult &&
        other.name == name &&
        other.location == location &&
        other.group == group &&
        other.timezone == timezone;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        location.hashCode ^
        group.hashCode ^
        timezone.hashCode;
  }

  static TerminalSearchResult fromJson(Map<String, dynamic> json) {
    return TerminalSearchResult(
      name: json['name'] as String,
      location: json['location'] as String,
      group: json['group'] as String,
      timezone: json['timezone'] as String,
    );
  }
}
