class Event {
  final String title;
  final String description;
  final List<String> guests;
  final DateTime startTime;
  final DateTime endTime;
  final String? imageUrl;

  Event({
    required this.title,
    required this.description,
    required this.guests,
    required this.startTime,
    required this.endTime,
    this.imageUrl,
  });
}
