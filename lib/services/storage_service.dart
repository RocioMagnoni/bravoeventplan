import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<XFile?> pickImage() async {
    final ImagePicker picker = ImagePicker();
    return await picker.pickImage(source: ImageSource.gallery);
  }

  Future<String?> uploadImage(XFile imageFile) async {
    try {
      String fileName = 'events/${DateTime.now().millisecondsSinceEpoch}_${imageFile.name}';
      Reference ref = _storage.ref().child(fileName);

      // Read the file content as bytes
      final Uint8List fileBytes = await imageFile.readAsBytes();

      // Use putData which works on all platforms
      UploadTask uploadTask = ref.putData(fileBytes);

      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }
}
