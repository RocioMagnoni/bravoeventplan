import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import '../../blocs/events/event_bloc.dart';
import '../../blocs/events/event_state.dart';
import '../../data/model/event.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay; 
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final azul = const Color(0xFF1E3A5F);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text('Calendario de Eventos', style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: BlocBuilder<EventBloc, EventState>(
        builder: (context, state) {
          if (state is! EventsLoaded) {
            return const Center(child: CircularProgressIndicator());
          }

          final Map<DateTime, List<Event>> eventsByDay = {};
          for (final event in state.events) {
            final day = DateTime.utc(event.startTime.year, event.startTime.month, event.startTime.day);
            if (eventsByDay[day] == null) {
              eventsByDay[day] = [];
            }
            eventsByDay[day]!.add(event);
          }

          List<Event> getEventsForDay(DateTime day) {
            final normalizedDay = DateTime.utc(day.year, day.month, day.day);
            return eventsByDay[normalizedDay] ?? [];
          }

          final selectedDayEvents = getEventsForDay(_selectedDay!);

          return Column(
            children: [
              Container(
                margin: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.yellow[300],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: azul, width: 4), // Blue and thicker border
                ),
                child: TableCalendar<Event>(
                  locale: 'es_ES',
                  firstDay: DateTime.utc(2020, 1, 1),
                  lastDay: DateTime.utc(2030, 12, 31),
                  focusedDay: _focusedDay,
                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                  onDaySelected: _onDaySelected,
                  eventLoader: getEventsForDay,
                  calendarStyle: CalendarStyle(
                    defaultTextStyle: const TextStyle(color: Colors.black),
                    weekendTextStyle: const TextStyle(color: Colors.black), // All days are black
                    todayDecoration: BoxDecoration(
                      color: azul.withOpacity(0.7),
                      shape: BoxShape.circle,
                    ),
                    selectedDecoration: BoxDecoration(
                      color: azul,
                      shape: BoxShape.circle,
                    ),
                     markerDecoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  headerStyle: HeaderStyle(
                    titleTextStyle: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold),
                    formatButtonVisible: false,
                    titleCentered: true,
                    leftChevronIcon: const Icon(Icons.chevron_left, color: Colors.black),
                    rightChevronIcon: const Icon(Icons.chevron_right, color: Colors.black),
                  ),
                  daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Colors.black),
                    weekendStyle: TextStyle(color: Colors.black), // All days are black
                  ),
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(
                child: ListView.builder(
                  itemCount: selectedDayEvents.length,
                  itemBuilder: (context, index) {
                    final event = selectedDayEvents[index];
                    return Card(
                      color: azul,
                      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      child: ListTile(
                        title: Text(event.title, style: const TextStyle(color: Colors.yellow, fontWeight: FontWeight.bold, fontSize: 18)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Text('Inicia: ${DateFormat('HH:mm').format(event.startTime)} hs', style: const TextStyle(color: Colors.white70)),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.location_on, color: Colors.white70, size: 16),
                                const SizedBox(width: 4),
                                Expanded(child: Text(event.location, style: const TextStyle(color: Colors.white70), overflow: TextOverflow.ellipsis)),
                              ],
                            ),
                          ],
                        ),
                        onTap: () { /* Optional: Navigate to event details */ },
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
