import 'dart:async';
import 'package:flutter/material.dart';
import '../data/model/event.dart';
import '../data/repositories/event_repository.dart';

class EventsViewModel extends ChangeNotifier {
  final EventRepository _eventRepository = EventRepository();
  List<Event> _events = [];
  late StreamSubscription _eventsSubscription;

  List<Event> get events => _events;

  EventsViewModel() {
    _listenToEvents();
  }

  void _listenToEvents() {
    _eventsSubscription = _eventRepository.getEvents().listen((events) {
      _events = events;
      notifyListeners();
    });
  }

  Future<void> addEvent(Event newEvent) {
    return _eventRepository.addEvent(newEvent);
  }

  @override
  void dispose() {
    _eventsSubscription.cancel();
    super.dispose();
  }
}
