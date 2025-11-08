import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:responsive_magnoni/data/model/event.dart';

class EventDetailsPage extends StatelessWidget {
  final Event event;

  const EventDetailsPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.black), // Force black icons
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.yellow,
          title: Text(
            event.title,
            style: const TextStyle(color: Colors.black),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event.imageUrl != null)
                event.imageUrl!.startsWith('http')
                    ? Image.network(
                        event.imageUrl!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        File(event.imageUrl!),
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inicio: ${DateFormat('dd/MM/yyyy HH:mm').format(event.startTime)}',
                      style: const TextStyle(
                          color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Fin:      ${DateFormat('dd/MM/yyyy HH:mm').format(event.endTime)}',
                       style: const TextStyle(
                          color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      event.description,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Invitados:',
                      style: TextStyle(
                          color: Colors.yellow, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    ...event.guests.map((guest) => Card(
                          color: Colors.yellow,
                          child: ListTile(
                            title: Text(
                              guest,
                              style: const TextStyle(color: Colors.black),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
