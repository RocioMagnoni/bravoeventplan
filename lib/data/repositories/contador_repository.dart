import 'package:cloud_firestore/cloud_firestore.dart';
import '../model/contador.dart';

class ContadorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static const String _collectionPath = 'app_state';
  static const String _documentId = 'contador';

  // Gets the single document for the counter
  Future<Contador> getContador() async {
    final doc = await _firestore.collection(_collectionPath).doc(_documentId).get();
    if (doc.exists) {
      return Contador.fromSnapshot(doc);
    }
    return Contador(); // Return default if it doesn't exist
  }

  // Updates the manual money value
  Future<void> updateManualMoney(double newAmount) {
    return _firestore
        .collection(_collectionPath)
        .doc(_documentId)
        .set({'manualMoney': newAmount}, SetOptions(merge: true)); // Use set with merge to create if not exists
  }
}
