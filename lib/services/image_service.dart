import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;

class ImageService {
  final ImagePicker _picker = ImagePicker();

  Future<XFile?> pickImage() async {
    return await _picker.pickImage(source: ImageSource.gallery);
  }

  Future<String?> saveImagePermanently(XFile imageFile) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String fileName = path.basename(imageFile.path);
      final String savedImagePath = path.join(appDir.path, fileName);

      final File image = File(imageFile.path);
      await image.copy(savedImagePath);

      return savedImagePath;
    } catch (e) {
      print("Error saving image: $e");
      return null;
    }
  }
}
