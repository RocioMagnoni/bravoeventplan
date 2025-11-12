import 'dart:async';
import 'package:flutter/material.dart';
import '../data/model/gallery_person.dart';
import '../data/repositories/gallery_repository.dart';

class GalleryViewModel extends ChangeNotifier {
  final GalleryRepository _repository = GalleryRepository();
  StreamSubscription? _peopleSubscription;

  List<GalleryPerson> _people = [];
  bool _isLoading = true;

  List<GalleryPerson> get people => _people;
  bool get isLoading => _isLoading;

  GalleryViewModel() {
    _listenToPeople();
  }

  void _listenToPeople() {
    _peopleSubscription = _repository.getPeopleStream().listen((people) {
      _people = people;
      _isLoading = false;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _peopleSubscription?.cancel();
    super.dispose();
  }

  Future<void> addPerson(GalleryPerson person) async {
    await _repository.addPerson(person);
  }

  Future<void> updatePerson(GalleryPerson person) async {
    await _repository.updatePerson(person);
  }

  Future<void> deletePerson(String personId) async {
    await _repository.deletePerson(personId);
  }
}
