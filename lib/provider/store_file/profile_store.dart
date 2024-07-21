import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileStore with Store {
  Observable<File?> profileImage = Observable<File?>(null);

  Future<void> pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      runInAction(() {
        profileImage.value = File(pickedFile.path);
        saveImageToPreferences(pickedFile.path);
      });
    }
  }

  Future<void> loadImageFromPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final imagePath = prefs.getString('profile_image');

    if (imagePath != null) {
      runInAction(() {
        profileImage.value = File(imagePath);
      });
    }
  }

  Future<void> saveImageToPreferences(String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profile_image', path);
  }
}
