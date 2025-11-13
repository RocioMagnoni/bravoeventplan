import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/gallery_person.dart';

class GalleryRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'gallery';

  // Get a stream of people from Firestore, ordered by ranking
  Stream<List<GalleryPerson>> getPeopleStream() {
    return _firestore
        .collection(_collectionPath)
        .orderBy('ranking', descending: true) // Order by ranking!
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => GalleryPerson.fromSnapshot(doc)).toList();
    });
  }

  // Add a new person to Firestore
  Future<void> addPerson(GalleryPerson person) {
    return _firestore.collection(_collectionPath).add(person.toJson());
  }

  // Update an existing person in Firestore
  Future<void> updatePerson(GalleryPerson person) {
    return _firestore.collection(_collectionPath).doc(person.id).update(person.toJson());
  }

  // Delete a person from Firestore
  Future<void> deletePerson(String personId) {
    return _firestore.collection(_collectionPath).doc(personId).delete();
  }
}
