import 'package:flutter/material.dart';

class EventsPageUnified extends StatefulWidget {
  @override
  _EventsPageUnifiedState createState() => _EventsPageUnifiedState();
}

class _EventsPageUnifiedState extends State<EventsPageUnified> {
  // Lista de eventos existentes
  final List<Map<String, dynamic>> _events = [
    {
      'name': 'Fiesta en Aron City',
      'description': 'La fiesta más cool del año en Aron City!',
      'datetime': DateTime(2025, 9, 20, 20, 0),
      'image': 'fiesta1.jpg',
      'guests': <Map<String, String>>[],
    },
    {
      'name': 'Competencia de músculos',
      'description': '¡Demuestra tus músculos y gana premios!',
      'datetime': DateTime(2025, 9, 21, 18, 0),
      'image': 'flexiones1.jpg',
      'guests': <Map<String, String>>[],
    },
  ];

  // Lista de invitados disponibles
  final List<Map<String, String>> allGuests = [
    {'name': 'Suzy', 'image': 'suzy.jpg'},
    {'name': 'Carl', 'image': 'carl.jpg'},
    {'name': 'Bunny', 'image': 'bunny.jpg'},
    {'name': 'Marcia', 'image': 'heather.jpg'},
  ];

  // Controladores del formulario
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  List<Map<String, String>> _selectedGuests = [];

  // Función para mostrar el formulario de nuevo evento
  void _showAddEventDialog() async {
    _nameController.clear();
    _descriptionController.clear();
    _selectedDate = null;
    _selectedTime = null;
    _selectedGuests = [];

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(builder: (context, setStateDialog) {
          return Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 20,
              right: 20,
              top: 20,
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Nombre del evento'),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        labelText: 'Descripción (opcional)'),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            DateTime? picked = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2023),
                              lastDate: DateTime(2030),
                            );
                            if (picked != null) {
                              setStateDialog(() => _selectedDate = picked);
                            }
                          },
                          child: Text(_selectedDate == null
                              ? 'Seleccionar Fecha'
                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'),
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            TimeOfDay? picked = await showTimePicker(
                              context: context,
                              initialTime: TimeOfDay.now(),
                            );
                            if (picked != null) {
                              setStateDialog(() => _selectedTime = picked);
                            }
                          },
                          child: Text(_selectedTime == null
                              ? 'Seleccionar Hora'
                              : '${_selectedTime!.hour}:${_selectedTime!.minute.toString().padLeft(2, '0')}'),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Text('Invitados disponibles:'),
                  Wrap(
                    spacing: 6,
                    children: allGuests.map((guest) {
                      final isSelected = _selectedGuests.contains(guest);
                      return ChoiceChip(
                        label: Text(
                          guest['name']!,
                          style: TextStyle(
                            color: isSelected ? Colors.black : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        selectedColor: Color(0xFF1E3A5F),
                        backgroundColor: Colors.yellow,
                        selected: isSelected,
                        onSelected: (val) {
                          setStateDialog(() {
                            if (val) {
                              _selectedGuests.add(guest);
                            } else {
                              _selectedGuests.remove(guest);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF1E3A5F)),
                    onPressed: () {
                      if (_nameController.text.isEmpty ||
                          _selectedDate == null ||
                          _selectedTime == null) return;

                      final dateTime = DateTime(
                        _selectedDate!.year,
                        _selectedDate!.month,
                        _selectedDate!.day,
                        _selectedTime!.hour,
                        _selectedTime!.minute,
                      );

                      setState(() {
                        _events.add({
                          'name': _nameController.text,
                          'description': _descriptionController.text,
                          'datetime': dateTime,
                          'image': 'event_placeholder.png',
                          'guests': List<Map<String, String>>.from(_selectedGuests),
                        });
                      });

                      Navigator.pop(context);
                    },
                    child: Text('Agregar Evento'),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Color(0xFF1E3A5F),
          onPressed: _showAddEventDialog,
          child: Icon(Icons.add),
        ),
        body: ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: _events.length,
          itemBuilder: (context, index) {
            final e = _events[index];
            final dt = e['datetime'] as DateTime;
            final guests = e['guests'] as List<Map<String, String>>;

            return Card(
              color: Colors.yellow,
              margin: EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${dt.day}/${dt.month}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w900,
                          color: Colors.black,
                          fontFamily: 'RobotoMono'),
                    ),
                    SizedBox(height: 6),
                    Text(
                      e['name'],
                      style: TextStyle(
                          fontSize: 16, color: Colors.black, fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 6),
                    Text(
                      e['description'],
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    if (guests.isNotEmpty)
                      Wrap(
                        spacing: 6,
                        children: guests.map((g) {
                          return InputChip(
                            label: Text(g['name']!),
                            backgroundColor: Color(0xFF1E3A5F),
                            labelStyle: TextStyle(color: Colors.black),
                            onDeleted: () {
                              setState(() {
                                e['guests'].remove(g);
                              });
                            },
                          );
                        }).toList(),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
