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

class EditPersonPage extends StatefulWidget {
  final GalleryPerson person;

  const EditPersonPage({super.key, required this.person});

  @override
  State<EditPersonPage> createState() => _EditPersonPageState();
}

class _EditPersonPageState extends State<EditPersonPage> {
  final _supabaseService = SupabaseStorageService();
  late TextEditingController _nameController;
  late TextEditingController _ageController;
  late TextEditingController _locationController;
  late TextEditingController _socialMediaController;
  late TextEditingController _interestsController; // New controller
  late TextEditingController _personalNoteController; // New controller
  XFile? _selectedImage;
  bool _isSaving = false;

  final _editPhrases = [
    "¡Johnny nunca olvida una cara hermosa!",
    "¡Actualizado con clase y buen peinado!",
    "¡Nada como mejorar los detalles, eh baby!",
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.person.name);
    _ageController = TextEditingController(text: widget.person.age.toString());
    _locationController = TextEditingController(text: widget.person.location);
    _socialMediaController = TextEditingController(text: widget.person.socialMedia);
    _interestsController = TextEditingController(text: widget.person.interests);
    _personalNoteController = TextEditingController(text: widget.person.personalNote);
  }

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

  Future<void> _saveChanges() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El nombre es obligatorio.')),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    String imageUrl = widget.person.imageUrl;
    if (_selectedImage != null) {
      final (url, error) = await _supabaseService.uploadImage(_selectedImage!);
      if (error != null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al subir imagen: $error')),
          );
          setState(() {
            _isSaving = false;
          });
        }
        return;
      }
      imageUrl = url!;
    }

    final updatedPerson = widget.person.copyWith(
      name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      location: _locationController.text,
      socialMedia: _socialMediaController.text,
      imageUrl: imageUrl,
      interests: _interestsController.text,
      personalNote: _personalNoteController.text,
    );

    if (mounted) {
      context.read<GalleryBloc>().add(UpdatePerson(updatedPerson));
      final randomPhrase = _editPhrases[Random().nextInt(_editPhrases.length)];
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
        title: const Text('Editar Personaje', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
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
                      : Image.network(widget.person.imageUrl, fit: BoxFit.cover),
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
                        onPressed: _saveChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.yellow,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                        ),
                        child: const Text('Guardar Cambios'),
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
