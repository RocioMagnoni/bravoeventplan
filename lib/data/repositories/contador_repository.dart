import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:responsive_magnoni/data/model/event.dart';
import 'package:rxdart/rxdart.dart';
import '../model/contador.dart';
import 'event_repository.dart';

class ContadorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final EventRepository _eventRepository;
  static const String _collectionPath = 'app_state';
  static const String _documentId = 'contador';

  ContadorRepository({required EventRepository eventRepository}) 
      : _eventRepository = eventRepository;

  // Stream for the manual money part of the counter
  Stream<Contador> _getManualMoneyStream() {
    return _firestore
        .collection(_collectionPath)
        .doc(_documentId)
        .snapshots()
        .map((doc) {
      if (doc.exists) {
        return Contador.fromSnapshot(doc);
      }
      return Contador(); // Return default if it doesn't exist
    });
  }

  // Stream for the total earnings from finished events
  Stream<double> _getEventEarningsStream() {
    return _eventRepository.getEvents().map((events) {
      return events
          .where((e) => e.status == EventStatus.finished)
          .fold<double>(0.0, (sum, e) => sum + e.totalEarned);
    });
  }

  // Combine both streams to get the final, unified Contador state stream
  Stream<Contador> getContadorStream() {
    return CombineLatestStream.combine3(
      _getManualMoneyStream(),
      _getEventEarningsStream(),
      _eventRepository.getEvents().map((events) => events.where((e) => e.status == EventStatus.finished).toList()),
      (Contador manualContador, double eventEarnings, List<Event> finishedEvents) {
        return manualContador.copyWith(
          gananciasDeEventos: eventEarnings,
          historialEventos: finishedEvents,
        );
      },
    );
  }

  // Updates the manual money value
  Future<void> updateManualMoney(double newAmount) {
    return _firestore
        .collection(_collectionPath)
        .doc(_documentId)
        .set({'manualMoney': newAmount}, SetOptions(merge: true));
  }
}
