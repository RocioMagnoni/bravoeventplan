import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../data/model/event.dart';
import '../../services/storage_service.dart';

class NewEventPage extends StatefulWidget {
  const NewEventPage({super.key});

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  final _storageService = StorageService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _guestController = TextEditingController();
  final List<String> _guests = [];
  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;
  XFile? _selectedImage;
  bool _isUploading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _guestController.dispose();
    super.dispose();
  }

  void _addGuest() {
    if (_guestController.text.isEmpty) return;
    setState(() {
      _guests.add(_guestController.text);
      _guestController.clear();
    });
  }

  Future<void> _selectDateTime(bool isStartTime) async {
    final initialDateTime = isStartTime ? _selectedStartTime : _selectedEndTime;
    final date = await showDatePicker(
      context: context,
      initialDate: initialDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date == null) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialDateTime ?? DateTime.now()),
    );
    if (time == null) return;

    setState(() {
      final selectedDateTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
      if (isStartTime) {
        _selectedStartTime = selectedDateTime;
      } else {
        _selectedEndTime = selectedDateTime;
      }
    });
  }

  Future<void> _pickImage() async {
    final image = await _storageService.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _saveEvent() async {
    if (_titleController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        _selectedStartTime == null ||
        _selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, completa todos los campos.')),
      );
      return;
    }

    if (_selectedStartTime!.isAfter(_selectedEndTime!)) {
        ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('La fecha de inicio no puede ser posterior a la de fin.')),
      );
      return;
    }

    setState(() {
      _isUploading = true;
    });

    String? imageUrl;
    if (_selectedImage != null) {
      imageUrl = await _storageService.uploadImage(_selectedImage!);
    }

    final newEvent = Event(
      title: _titleController.text,
      description: _descriptionController.text,
      guests: _guests,
      startTime: _selectedStartTime!,
      endTime: _selectedEndTime!,
      imageUrl: imageUrl,
    );

    if (mounted) {
      Navigator.pop(context, newEvent);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        leading: Navigator.canPop(context)
            ? IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              )
            : null,
        title: const Text('Nuevo Evento', style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Título', style: TextStyle(color: Colors.yellow, fontSize: 16)),
              TextField(controller: _titleController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Título del evento', hintStyle: TextStyle(color: Colors.white54))),
              const SizedBox(height: 15),

              const Text('Descripción', style: TextStyle(color: Colors.yellow, fontSize: 16)),
              TextField(controller: _descriptionController, style: const TextStyle(color: Colors.white), maxLines: 3, decoration: const InputDecoration(hintText: 'Descripción del evento', hintStyle: TextStyle(color: Colors.white54))),
              const SizedBox(height: 20),

              const Text('Imagen', style: TextStyle(color: Colors.yellow, fontSize: 16)),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  height: 150,
                  width: double.infinity,
                  decoration: BoxDecoration(color: Colors.grey[800], borderRadius: BorderRadius.circular(10), border: Border.all(color: Colors.yellow, width: 2)),
                  child: _selectedImage != null
                      ? (kIsWeb
                          ? Image.network(_selectedImage!.path, fit: BoxFit.cover)
                          : Image.file(File(_selectedImage!.path), fit: BoxFit.cover))
                      : const Center(child: Icon(Icons.add_a_photo, color: Colors.yellow, size: 50)),
                ),
              ),
              const SizedBox(height: 20),

              const Text('Inicio del evento', style: TextStyle(color: Colors.yellow, fontSize: 16)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Text(_selectedStartTime == null ? 'No seleccionada' : DateFormat('dd/MM/yyyy HH:mm').format(_selectedStartTime!), style: const TextStyle(color: Colors.white, fontSize: 16))),
                  ElevatedButton(onPressed: () => _selectDateTime(true), style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow, foregroundColor: Colors.black), child: const Text('Seleccionar')),
                ],
              ),
              const SizedBox(height: 20),

              const Text('Fin del evento', style: TextStyle(color: Colors.yellow, fontSize: 16)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: Text(_selectedEndTime == null ? 'No seleccionada' : DateFormat('dd/MM/yyyy HH:mm').format(_selectedEndTime!), style: const TextStyle(color: Colors.white, fontSize: 16))),
                  ElevatedButton(onPressed: () => _selectDateTime(false), style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow, foregroundColor: Colors.black), child: const Text('Seleccionar')),
                ],
              ),
              const SizedBox(height: 20),

              const Text('Invitados', style: TextStyle(color: Colors.yellow, fontSize: 16)),
              Row(
                children: [
                  Expanded(child: TextField(controller: _guestController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Agregar invitado', hintStyle: TextStyle(color: Colors.white54)))),
                  const SizedBox(width: 10),
                  ElevatedButton(onPressed: _addGuest, style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow, foregroundColor: Colors.black), child: const Text('Agregar')),
                ],
              ),
              const SizedBox(height: 10),
              ..._guests.map((guest) => Card(color: Colors.yellow, child: ListTile(title: Text(guest, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.black), onPressed: () => setState(() => _guests.remove(guest)))))),
              const SizedBox(height: 20),
              
              Center(
                child: _isUploading
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _saveEvent,
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow, foregroundColor: Colors.black, padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15)),
                        child: const Text('Guardar Evento'),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}