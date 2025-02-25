import 'dart:io';

import 'package:image_picker/image_picker.dart';

abstract class UpdateUserRepository {
  Future<void> updateUser(String name, String email, String photoUrl);

  Future<String> uploadImageToFirebase(File file);

  Future<XFile> selectImageFromGallery();
}
