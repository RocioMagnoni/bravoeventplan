import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:responsive_magnoni/blocs/events/event_bloc.dart';
import 'package:responsive_magnoni/blocs/events/event_event.dart';
import 'package:responsive_magnoni/blocs/events/event_state.dart';
import 'package:responsive_magnoni/data/model/event.dart';
import 'package:responsive_magnoni/view/pages/calendar_page.dart';
import 'package:responsive_magnoni/view/pages/event_details_page.dart';
import 'package:responsive_magnoni/view/pages/new_event_page.dart';
import 'package:responsive_magnoni/view/pages/edit_event_page.dart';
import '../widgets/ticket_clipper.dart';

// A custom painter for vertical dashed lines
class VerticalDashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.4)
      ..strokeWidth = 1;

    const dashHeight = 4;
    const dashSpace = 3;
    double startY = 0;

    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class EventsPageUnified extends StatelessWidget {
  const EventsPageUnified({super.key});

  @override
  Widget build(BuildContext context) {
    return const _EventsPageUnifiedView();
  }
}

class _EventsPageUnifiedView extends StatelessWidget {
  const _EventsPageUnifiedView();

  void _openEventDetails(BuildContext context, Event event) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<EventBloc>(context),
          child: EventDetailsPage(event: event),
        ),
      ),
    );
  }

  Future<void> _openEditEvent(BuildContext context, Event event) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(
        builder: (_) => BlocProvider.value(
          value: BlocProvider.of<EventBloc>(context),
          child: EditEventPage(event: event),
        ),
      ),
    );
  }

  Future<void> _createNewEvent(BuildContext context) async {
    final newEvent = await Navigator.push<Event>(
      context,
      MaterialPageRoute(builder: (_) => const NewEventPage()),
    );

    if (newEvent != null && context.mounted) {
      context.read<EventBloc>().add(AddEvent(newEvent));
    }
  }

  void _openCalendarView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CalendarPage()),
    );
  }

  String _getStatusText(EventStatus status) {
    switch (status) {
      case EventStatus.inProgress:
        return 'EN CURSO';
      case EventStatus.upcoming:
        return 'PRÓXIMO';
      case EventStatus.finished:
        return 'FINALIZADO';
    }
  }

  Color _getStatusColor(EventStatus status) {
    switch (status) {
      case EventStatus.inProgress:
        return Colors.green;
      case EventStatus.upcoming:
        return Colors.orange;
      case EventStatus.finished:
        return Colors.red;
    }
  }

  int _getStatusSortPriority(EventStatus status) {
    switch (status) {
      case EventStatus.inProgress:
        return 0;
      case EventStatus.upcoming:
        return 1;
      case EventStatus.finished:
        return 2;
    }
  }

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF1E3A5F);
    final ticketBorderColor = const Color(0xFF1E3A5F);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        centerTitle: true,
        title: const Text(
          'Eventos',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'calendar_fab',
            backgroundColor: azul,
            child: const Icon(Icons.calendar_today, color: Colors.black),
            onPressed: () => _openCalendarView(context),
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'add_event_fab',
            backgroundColor: azul,
            child: const Icon(Icons.add, color: Colors.black),
            onPressed: () => _createNewEvent(context),
          ),
        ],
      ),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is EventsLoading || state is EventsInitial) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is EventsLoaded) {
            if (state.events.isEmpty) {
              return const Center(
                child: Text(
                  'No hay eventos creados.',
                  style: TextStyle(color: Colors.yellow, fontSize: 18),
                ),
              );
            }

            final sortedEvents = List<Event>.from(state.events)
              ..sort((a, b) {
                final priorityA = _getStatusSortPriority(a.status);
                final priorityB = _getStatusSortPriority(b.status);
                if (priorityA != priorityB) {
                  return priorityA.compareTo(priorityB);
                }
                return a.startTime.compareTo(b.startTime);
              });

            return ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: sortedEvents.length,
              itemBuilder: (context, index) {
                final event = sortedEvents[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ClipPath(
                    clipper: TicketClipper(),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [ticketBorderColor, ticketBorderColor.withOpacity(0.7)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      padding: const EdgeInsets.all(5), // This creates the border width
                      child: Container(
                        color: Colors.yellow,
                        child: IntrinsicHeight( // Ensures the dashed line can calculate its height
                          child: Row(
                            children: [
                              // Main ticket content
                              Expanded(
                                child: InkWell(
                                  onTap: () => _openEventDetails(context, event),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
                                        child: Text(
                                          DateFormat('dd/MM/yyyy HH:mm').format(event.startTime),
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        ),
                                      ),
                                      Text(event.title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 22)),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                const Icon(Icons.location_on, color: Colors.black54, size: 16),
                                                const SizedBox(width: 4),
                                                Flexible(child: Text(event.location, style: const TextStyle(color: Colors.black54), overflow: TextOverflow.ellipsis)),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Finaliza: ${DateFormat('dd/MM/yyyy HH:mm').format(event.endTime)}',
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.edit, color: azul),
                                            onPressed: () => _openEditEvent(context, event),
                                          ),
                                          IconButton(
                                            icon: Icon(Icons.delete, color: Colors.red[900]),
                                            onPressed: () {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext ctx) {
                                                  return AlertDialog(
                                                    title: const Text('Confirmar Borrado'),
                                                    content: const Text('¿Estás seguro de que quieres borrar este evento?'),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () => Navigator.of(ctx).pop(),
                                                        child: const Text('Cancelar'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          context.read<EventBloc>().add(DeleteEvent(event.id!));
                                                          Navigator.of(ctx).pop();
                                                        },
                                                        child: Text('Borrar', style: TextStyle(color: Colors.red[900])),
                                                      ),
                                                    ],
                                                  );
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              // Dashed line and the stub
                              SizedBox(
                                width: 90, // Width for the stub part
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 20.0), // Padding to not reach edges
                                      child: CustomPaint(
                                        size: const Size(1, double.infinity),
                                        painter: VerticalDashedLinePainter(),
                                      ),
                                    ),
                                    Expanded(
                                      child: RotatedBox(
                                        quarterTurns: 3,
                                        child: Center(
                                          child: Container(
                                            margin: const EdgeInsets.all(10),
                                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                            decoration: BoxDecoration(
                                              color: _getStatusColor(event.status),
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: Text(
                                              _getStatusText(event.status),
                                              textAlign: TextAlign.center,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else if (state is EventsError) {
            return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
