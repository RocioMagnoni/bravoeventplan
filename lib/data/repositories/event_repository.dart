import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/event.dart';
import '../model/guest.dart'; // Import the Guest model

class EventRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'events';

  Stream<List<Event>> getEvents() {
    return _firestore
        .collection(_collectionPath)
        .orderBy('startTime', descending: false)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        // Use the factory constructor from the Event model
        return Event.fromSnapshot(doc);
      }).toList();
    });
  }

  Future<void> addEvent(Event event) {
    // Use the toJson method from the Event model
    return _firestore.collection(_collectionPath).add(event.toJson());
  }

  Future<void> updateEvent(Event event) {
    // Use the toJson method from the Event model
    return _firestore.collection(_collectionPath).doc(event.id).update(event.toJson());
  }

  Future<void> deleteEvent(String eventId) {
    return _firestore.collection(_collectionPath).doc(eventId).delete();
  }
}
