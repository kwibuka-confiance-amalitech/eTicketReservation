import 'dart:io';

import 'package:car_ticket/domain/repositories/settings/update_user_repository.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UpdateUserRepositoryImplementation implements UpdateUserRepository {
  @override
  Future<XFile> selectImageFromGallery() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile!;
  }

  @override
  Future<String> uploadImageToFirebase(File file) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef =
        FirebaseStorage.instance.ref().child("my-images").child(fileName);
    UploadTask uploadTask = storageRef.putFile(
        file,
        SettableMetadata(
          contentType: 'image/jpeg',
          customMetadata: {'picked-file-path': file.path},
        ));
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  @override
  Future<void> updateUser(String name, String email, String photoUrl) {
    // TODO: implement updateUser
    throw UnimplementedError();
  }
}
