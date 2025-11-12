import 'dart:io';
import 'dart:math';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../blocs/gallery/gallery_bloc.dart';
import '../../blocs/gallery/gallery_event.dart';
import '../../data/model/gallery_person.dart';
import '../../services/supabase_storage_service.dart';

class NewPersonPage extends StatefulWidget {
  const NewPersonPage({super.key});

  @override
  State<NewPersonPage> createState() => _NewPersonPageState();
}

class _NewPersonPageState extends State<NewPersonPage> {
  final _supabaseService = SupabaseStorageService();
  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _locationController = TextEditingController();
  final _socialMediaController = TextEditingController();
  final _interestsController = TextEditingController(); // New controller
  final _personalNoteController = TextEditingController(); // New controller
  XFile? _selectedImage;
  bool _isSaving = false;

  final _newGirlPhrases = [
    "¡Woah mamá! ¡Una nueva belleza en la lista!",
    "¡Añadida con estilo, baby!",
    "¡Esta sí que podría romper corazones… y peines!",
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _locationController.dispose();
    _socialMediaController.dispose();
    _interestsController.dispose();
    _personalNoteController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final image = await _supabaseService.pickImage();
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _savePerson() async {
    if (_nameController.text.isEmpty || _selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre y la imagen son obligatorios.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    final (imageUrl, error) = await _supabaseService.uploadImage(_selectedImage!);

    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $error')),
      );
      setState(() {
        _isSaving = false;
      });
      return;
    }

    final newPerson = GalleryPerson(
      name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      location: _locationController.text,
      socialMedia: _socialMediaController.text,
      imageUrl: imageUrl!,
      interests: _interestsController.text,
      personalNote: _personalNoteController.text,
    );

    if (mounted) {
      context.read<GalleryBloc>().add(AddPerson(newPerson));
      final randomPhrase = _newGirlPhrases[Random().nextInt(_newGirlPhrases.length)];
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
        title: const Text('Añadir a la Galería', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Imagen', style: TextStyle(color: Colors.yellow, fontSize: 16)),
              const SizedBox(height: 10),
              GestureDetector(
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
              ),
              const SizedBox(height: 20),
              
              _buildTextField(_nameController, 'Nombre'),
              _buildTextField(_ageController, 'Edad', keyboardType: TextInputType.number),
              _buildTextField(_locationController, 'Ubicación'),
              _buildTextField(_socialMediaController, 'Red Social (@usuario)'),
              _buildTextField(_interestsController, 'Intereses'),
              _buildTextField(_personalNoteController, 'Nota Personal', maxLines: 3),
              
              const SizedBox(height: 30),
              Center(
                child: _isSaving
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: _savePerson,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        child: const Text('Guardar'),
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
          enabledBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.yellow),
          ),
          focusedBorder: const UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white, width: 2),
          ),
        ),
      ),
    );
  }
}
