import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../data/model/event.dart';
import '../../viewmodel/events_viewmodel.dart';
import 'event_details_page.dart';
import 'new_event_page.dart';

class EventsPageUnified extends StatelessWidget {
  const EventsPageUnified({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => EventsViewModel(),
      child: const _EventsPageUnifiedView(),
    );
  }
}

class _EventsPageUnifiedView extends StatelessWidget {
  const _EventsPageUnifiedView();

  void _openEventDetails(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EventDetailsPage(event: event),
      ),
    );
  }

  Future<void> _createNewEvent(BuildContext context) async {
    final newEvent = await Navigator.push<Event>(
      context,
      MaterialPageRoute(builder: (_) => const NewEventPage()),
    );

    if (newEvent != null && context.mounted) {
      context.read<EventsViewModel>().addEvent(newEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('Eventos', style: TextStyle(color: Colors.black)),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () => _createNewEvent(context),
      ),
      body: Consumer<EventsViewModel>(
        builder: (context, viewModel, child) {
          return viewModel.events.isEmpty
              ? const Center(
                  child: Text(
                    'No hay eventos creados.',
                    style: TextStyle(color: Colors.yellow, fontSize: 18),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: viewModel.events.length,
                  itemBuilder: (context, index) {
                    final event = viewModel.events[index];
                    return Card(
                      color: Colors.yellow,
                      child: ListTile(
                        leading: event.imageUrl != null
                            ? Image.network(
                                event.imageUrl!,
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              )
                            : const Icon(Icons.event, size: 50, color: Colors.black),
                        title: Text(event.title,
                            style: const TextStyle(
                                color: Colors.black, fontWeight: FontWeight.bold)),
                        subtitle: Text(
                          'Inicia: ${DateFormat('dd/MM/yyyy HH:mm').format(event.startTime)}',
                          style: const TextStyle(color: Colors.black54),
                        ),
                        onTap: () => _openEventDetails(context, event),
                      ),
                    );
                  },
                );
        },
      ),
    );
  }
}
