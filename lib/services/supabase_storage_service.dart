import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseStorageService {
  final _supabase = Supabase.instance.client;
  final _picker = ImagePicker();
  final _bucketName = 'bravoeventplan'; 

  Future<XFile?> pickImage() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 800,
    );
  }

  // Now returns a tuple: [String? url, String? error]
  Future<(String?, String?)> uploadImage(XFile imageFile) async {
    try {
      final String fileName = '${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      final String filePath = 'public/$fileName'; 

      await _supabase.storage.from(_bucketName).upload(
            filePath,
            File(imageFile.path),
          );

      final String publicUrl = _supabase.storage.from(_bucketName).getPublicUrl(filePath);

      return (publicUrl, null); // Success: return URL, no error
    } catch (e) {
      print("Error uploading image to Supabase: $e");
      return (null, e.toString()); // Failure: return no URL, and the error message
    }
  }
}
