import 'package:equatable/equatable.dart';

enum EventStatus { upcoming, inProgress, finished }

class Event extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String location; // Added location
  final List<String> guests;
  final DateTime startTime;
  final DateTime endTime;
  final String? imageUrl;

  const Event({
    this.id,
    required this.title,
    required this.description,
    required this.location, // Added location
    required this.guests,
    required this.startTime,
    required this.endTime,
    this.imageUrl,
  });

  EventStatus get status {
    final now = DateTime.now().toUtc();
    final start = startTime.toUtc();
    final end = endTime.toUtc();

    if (now.isBefore(start)) {
      return EventStatus.upcoming;
    } else if (now.isAfter(start) && now.isBefore(end)) {
      return EventStatus.inProgress;
    } else {
      return EventStatus.finished;
    }
  }

  @override
  List<Object?> get props => [id, title, description, location, guests, startTime, endTime, imageUrl];
}
