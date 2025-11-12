import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'guest.dart';

enum EventStatus { upcoming, inProgress, finished }

class Event extends Equatable {
  final String? id;
  final String title;
  final String description;
  final String location;
  final List<Guest> guests;
  final DateTime startTime;
  final DateTime endTime;
  final String? imageUrl;
  final double pricePerGuest; // New field
  final double totalEarned;   // New field

  const Event({
    this.id,
    required this.title,
    required this.description,
    required this.location,
    required this.guests,
    required this.startTime,
    required this.endTime,
    this.imageUrl,
    this.pricePerGuest = 0.0,
    this.totalEarned = 0.0,
  });

  EventStatus get status {
    final now = DateTime.now();
    if (now.isBefore(startTime)) {
      return EventStatus.upcoming;
    } else if (now.isAfter(startTime) && now.isBefore(endTime)) {
      return EventStatus.inProgress;
    } else {
      return EventStatus.finished;
    }
  }

  factory Event.fromSnapshot(DocumentSnapshot snap) {
    final data = snap.data() as Map<String, dynamic>;
    
    final List<dynamic> guestData = data['guests'] ?? [];
    List<Guest> guestList = [];
    if (guestData.isNotEmpty && guestData.first is Map) {
        guestList = guestData.map((g) => Guest.fromMap(g as Map<String, dynamic>)).toList();
    }

    return Event(
      id: snap.id,
      title: data['title'] ?? 'No Title',
      description: data['description'] ?? 'No Description',
      location: data['location'] ?? 'No Location',
      guests: guestList,
      startTime: (data['startTime'] as Timestamp).toDate(),
      endTime: (data['endTime'] as Timestamp).toDate(),
      imageUrl: data['imageUrl'],
      pricePerGuest: (data['pricePerGuest'] as num?)?.toDouble() ?? 0.0,
      totalEarned: (data['totalEarned'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'location': location,
      'guests': guests.map((g) => g.toMap()).toList(),
      'startTime': startTime,
      'endTime': endTime,
      'imageUrl': imageUrl,
      'pricePerGuest': pricePerGuest,
      'totalEarned': totalEarned,
    };
  }
  
  Event copyWith({
    String? id,
    String? title,
    String? description,
    String? location,
    List<Guest>? guests,
    DateTime? startTime,
    DateTime? endTime,
    String? imageUrl,
    double? pricePerGuest,
    double? totalEarned,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      location: location ?? this.location,
      guests: guests ?? this.guests,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      imageUrl: imageUrl ?? this.imageUrl,
      pricePerGuest: pricePerGuest ?? this.pricePerGuest,
      totalEarned: totalEarned ?? this.totalEarned,
    );
  }

  @override
  List<Object?> get props => [
        id, title, description, location, guests, startTime, endTime, imageUrl, pricePerGuest, totalEarned
      ];
}
