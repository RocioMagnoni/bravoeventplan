import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
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

class EventsPageUnified extends StatefulWidget {
  const EventsPageUnified({super.key});

  @override
  State<EventsPageUnified> createState() => _EventsPageUnifiedState();
}

class _EventsPageUnifiedState extends State<EventsPageUnified> with TickerProviderStateMixin {
  late final AnimationController _lottieController;
  bool _showConfetti = false;
  static const _confettiDuration = Duration(seconds: 3);

  static const _editFinishedPhrases = [
    "¡Woah, nena! El pasado no se puede cambiar, ni siquiera por mí.",
    "Esa fiesta ya es historia, y la historia no se edita.",
  ];

  static const _editInProgressPhrases = [
    "¡Hey, nena! Una fiesta en marcha no se edita, ¡se vive!",
    "¡No toques nada! La perfección está en curso.",
  ];

  static const _deleteInProgressPhrases = [
    "¡Hey! ¡Una fiesta en marcha es sagrada!",
    "No puedes parar esta fiesta, ¡está que arde!",
  ];

  @override
  void initState() {
    super.initState();
    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  void _triggerConfetti() {
    if (mounted) {
      setState(() {
        _showConfetti = true;
      });
    }
    _lottieController
      ..duration = _confettiDuration
      ..forward(from: 0);

    Future.delayed(_confettiDuration, () {
      if (mounted) {
        setState(() {
          _showConfetti = false;
        });
      }
    });
  }

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

  Future<void> _handleEdit(BuildContext context, Event event) async {
    if (event.status == EventStatus.finished) {
      final randomPhrase = _editFinishedPhrases[Random().nextInt(_editFinishedPhrases.length)];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(randomPhrase, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.yellow),
      );
      return;
    }
    if (event.status == EventStatus.inProgress) {
      final randomPhrase = _editInProgressPhrases[Random().nextInt(_editInProgressPhrases.length)];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(randomPhrase, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.yellow),
      );
      return;
    }
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

  void _handleDelete(BuildContext context, Event event) {
    if (event.status == EventStatus.inProgress) {
      final randomPhrase = _deleteInProgressPhrases[Random().nextInt(_deleteInProgressPhrases.length)];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(randomPhrase, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.yellow),
      );
      return;
    }

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
  }

  void _openCalendarView(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CalendarPage()),
    );
  }

  Future<void> _createNewEvent(BuildContext context) async {
    await Navigator.push<void>(
      context,
      MaterialPageRoute(builder: (_) => const NewEventPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF1E3A5F);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        centerTitle: true,
        title: const Text(
          'Eventos Geniales',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
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
      body: Stack(
        children: [
          BlocConsumer<EventBloc, EventState>(
             listener: (context, state) {
              if (state is EventCreationSuccess) {
                _triggerConfetti();
              }
            },
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

                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: state.events.length,
                  itemBuilder: (context, index) {
                    final event = state.events[index];
                    return _AnimatedEventTicket(
                      event: event,
                      onTap: () => _openEventDetails(context, event),
                      onEdit: () => _handleEdit(context, event),
                      onDelete: () => _handleDelete(context, event),
                    );
                  },
                );
              } else if (state is EventsError) {
                return Center(child: Text(state.message, style: const TextStyle(color: Colors.red)));
              }
              return const SizedBox.shrink();
            },
          ),
          if (_showConfetti)
            Align(
              alignment: Alignment.center,
              child: Lottie.asset(
                'assets/animations/confetti.json', 
                controller: _lottieController,
              ),
            ),
        ],
      ),
    );
  }
}


class _AnimatedEventTicket extends StatefulWidget {
  final Event event;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AnimatedEventTicket({
    required this.event,
    required this.onTap,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  _AnimatedEventTicketState createState() => _AnimatedEventTicketState();
}

class _AnimatedEventTicketState extends State<_AnimatedEventTicket> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward().then((_) {
      _controller.reverse().then((_) {
        widget.onTap();
      });
    });
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

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF1E3A5F);
    final ticketBorderColor = const Color(0xFF1E3A5F);
    bool isEditable = widget.event.status == EventStatus.upcoming;

    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _animation,
        child: Padding(
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
              padding: const EdgeInsets.all(5),
              child: Container(
                color: Colors.yellow,
                child: IntrinsicHeight(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0, bottom: 4.0),
                              child: Text(
                                DateFormat('dd/MM/yyyy HH:mm').format(widget.event.startTime),
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            Text(widget.event.title, textAlign: TextAlign.center, style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 22)),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.location_on, color: Colors.black54, size: 16),
                                      const SizedBox(width: 4),
                                      Flexible(child: Text(widget.event.location, style: const TextStyle(color: Colors.black54), overflow: TextOverflow.ellipsis)),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Finaliza: ${DateFormat('dd/MM/yyyy HH:mm').format(widget.event.endTime)}',
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
                                  icon: Icon(Icons.edit, color: isEditable ? azul : Colors.grey),
                                  onPressed: widget.onEdit, // Use callback directly
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: widget.event.status == EventStatus.inProgress ? Colors.grey : Colors.red[900]),
                                  onPressed: widget.onDelete, // Use callback directly
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 90,
                        child: Row(
                          children: [
                            RepaintBoundary(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 20.0),
                                child: CustomPaint(
                                  size: const Size(1, double.infinity),
                                  painter: VerticalDashedLinePainter(),
                                ),
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
                                      color: _getStatusColor(widget.event.status),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: Text(
                                      _getStatusText(widget.event.status),
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
        ),
      ),
    );
  }
}
