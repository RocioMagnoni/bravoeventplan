import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event.dart';

class EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'events';

  Stream<List<Event>> getEvents() {
    return _firestore.collection(_collectionPath).snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return Event(
          title: data['title'] ?? '',
          description: data['description'] ?? '',
          guests: List<String>.from(data['guests'] ?? []),
          startTime: (data['startTime'] as Timestamp).toDate(),
          endTime: (data['endTime'] as Timestamp).toDate(),
          imageUrl: data['imageUrl'],
        );
      }).toList();
    });
  }

  Future<void> addEvent(Event event) {
    return _firestore.collection(_collectionPath).add({
      'title': event.title,
      'description': event.description,
      'guests': event.guests,
      'startTime': Timestamp.fromDate(event.startTime),
      'endTime': Timestamp.fromDate(event.endTime),
      'imageUrl': event.imageUrl,
    });
  }
}
