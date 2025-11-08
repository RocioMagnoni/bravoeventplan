import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final _supabase = Supabase.instance.client;
  final _picker = ImagePicker();

  // Method to pick an image from the gallery with compression
  Future<XFile?> pickImage() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50, // Compress image to 50% of original quality
      maxWidth: 800,    // Resize image to a max width of 800px
    );
  }

  // Method to upload an image to Supabase Storage and get the public URL
  Future<String?> uploadImage(XFile imageFile) async {
    try {
      // Create a unique file path
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      final String filePath = 'public/$fileName'; // Upload to a 'public' folder

      // Upload the file
      await _supabase.storage.from('images').upload(
            filePath,
            File(imageFile.path),
          );

      // Get the public URL of the uploaded file
      final String publicUrl = _supabase.storage.from('images').getPublicUrl(filePath);

      return publicUrl;
    } catch (e) {
      print("Error uploading image to Supabase: $e");
      return null;
    }
  }
}
