import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:responsive_magnoni/data/model/guest.dart';
import '../../blocs/events/event_bloc.dart';
import '../../blocs/events/event_event.dart';
import '../../data/model/event.dart';
import '../../services/supabase_storage_service.dart';

class NewEventPage extends StatefulWidget {
  const NewEventPage({super.key});

  @override
  State<NewEventPage> createState() => _NewEventPageState();
}

class _NewEventPageState extends State<NewEventPage> {
  final _supabaseService = SupabaseStorageService();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _guestController = TextEditingController();
  final List<Guest> _guests = [];
  DateTime? _selectedStartTime;
  DateTime? _selectedEndTime;
  XFile? _selectedImage;
  bool _isSaving = false;

  final _johnnyPhrases = [
    "¡Uooh, mamá! ¡Evento guardado!",
    "¡Añadida con estilo, baby!",
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _priceController.dispose();
    _guestController.dispose();
    super.dispose();
  }

  void _addGuest() {
    if (_guestController.text.isEmpty) return;
    setState(() {
      _guests.add(Guest(name: _guestController.text, status: GuestStatus.pending));
      _guestController.clear();
    });
  }

  Future<void> _selectDateTime(bool isStartTime) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000), 
        lastDate: DateTime(2101)
    );
    if (pickedDate == null) return;

    final TimeOfDay? pickedTime = await showTimePicker(
        context: context, 
        initialTime: TimeOfDay.now()
    );
    if (pickedTime == null) return;

    setState(() {
      final fullDateTime = DateTime(pickedDate.year, pickedDate.month, pickedDate.day, pickedTime.hour, pickedTime.minute);
      if (isStartTime) {
        _selectedStartTime = fullDateTime;
      } else {
        _selectedEndTime = fullDateTime;
      }
    });
  }

  Future<void> _pickImage() async {
    final image = await _supabaseService.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _saveEvent() async {
    if (_titleController.text.isEmpty || _selectedStartTime == null || _selectedEndTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Título y fechas son obligatorios.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    String? imageUrl;
    if (_selectedImage != null) {
      final (url, error) = await _supabaseService.uploadImage(_selectedImage!);
      if (error != null) {
        if(mounted){
           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al subir imagen: $error')));
           setState(() => _isSaving = false);
        }
        return;
      }
      imageUrl = url;
    }

    final newEvent = Event(
      title: _titleController.text,
      description: _descriptionController.text,
      location: _locationController.text,
      guests: _guests,
      startTime: _selectedStartTime!,
      endTime: _selectedEndTime!,
      imageUrl: imageUrl,
      pricePerGuest: double.tryParse(_priceController.text) ?? 0.0,
    );

    if (mounted) {
      context.read<EventBloc>().add(AddEvent(newEvent));
      final randomPhrase = _johnnyPhrases[Random().nextInt(_johnnyPhrases.length)];
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(randomPhrase, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)), backgroundColor: Colors.yellow),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        centerTitle: true,
        title: const Text('Nuevo Evento', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 20),
              _buildTextField(_titleController, 'Título'),
              _buildTextField(_descriptionController, 'Descripción', maxLines: 3),
              _buildTextField(_locationController, 'Ubicación'),
              _buildTextField(_priceController, 'Valor por Invitado', keyboardType: TextInputType.number),
              const SizedBox(height: 20),
              _buildDateTimePicker('Inicio del evento', _selectedStartTime, true),
              _buildDateTimePicker('Fin del evento', _selectedEndTime, false),
              const SizedBox(height: 20),
              const Text('Invitados', style: TextStyle(color: Colors.yellow, fontSize: 16)),
              _buildGuestInputField(),
              const SizedBox(height: 10),
              _buildGuestList(),
              const SizedBox(height: 30),
              Center(
                child: _isSaving
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

  Widget _buildTextField(TextEditingController controller, String label, {TextInputType keyboardType = TextInputType.text, int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.yellow),
          enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.yellow)),
          focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.white, width: 2)),
        ),
      ),
    );
  }
  
  Widget _buildImagePicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.yellow, width: 2),
        ),
        child: _selectedImage != null
            ? (kIsWeb
                ? Image.network(_selectedImage!.path, fit: BoxFit.cover)
                : Image.file(File(_selectedImage!.path), fit: BoxFit.cover))
            : const Center(child: Icon(Icons.add_a_photo, color: Colors.yellow, size: 50)),
      ),
    );
  }

  Widget _buildDateTimePicker(String label, DateTime? selectedTime, bool isStart) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Colors.yellow, fontSize: 16)),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(child: Text(selectedTime == null ? 'No seleccionada' : DateFormat('dd/MM/yyyy HH:mm').format(selectedTime), style: const TextStyle(color: Colors.white, fontSize: 16))),
            ElevatedButton(onPressed: () => _selectDateTime(isStart), style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow, foregroundColor: Colors.black), child: const Text('Seleccionar')),
          ],
        ),
      ],
    );
  }

  Widget _buildGuestInputField() {
    return Row(
      children: [
        Expanded(child: TextField(controller: _guestController, style: const TextStyle(color: Colors.white), decoration: const InputDecoration(hintText: 'Agregar invitado', hintStyle: TextStyle(color: Colors.white54)))),
        const SizedBox(width: 10),
        ElevatedButton(onPressed: _addGuest, style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow, foregroundColor: Colors.black), child: const Text('Agregar')),
      ],
    );
  }

  Widget _buildGuestList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _guests.length,
      itemBuilder: (context, index) {
        final guest = _guests[index];
        return Card(
          color: Colors.yellow,
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ListTile(
            title: Text(guest.name, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
            trailing: IconButton(icon: const Icon(Icons.delete, color: Colors.black), onPressed: () => setState(() => _guests.remove(guest))),
          ),
        );
      },
    );
  }
}
