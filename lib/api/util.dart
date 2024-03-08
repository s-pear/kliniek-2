import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kliniek/api/firestore_services.dart';

User? user = FirebaseAuth.instance.currentUser;

pickImg2(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    return await file.readAsBytes();
  }
}

pickImg(ImageSource source, uid) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    Uint8List img = await file.readAsBytes();
    String urlImg = await FireStoreServices.uploadImgToStorage(uid, img);
    await FirebaseAuth.instance.currentUser?.updatePhotoURL(urlImg);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({"img": urlImg});
  }
}

pickImgDoc(ImageSource source, uid) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    Uint8List img = await file.readAsBytes();
    String urlImg = await FireStoreServices.uploadImgToStorage(uid, img);
    await FirebaseAuth.instance.currentUser?.updatePhotoURL(urlImg);
    await FirebaseFirestore.instance
        .collection('doctor')
        .doc(uid)
        .update({"img": urlImg});
  }
}

pickImgD(ImageSource source, uid) async {
  final ImagePicker imagePicker = ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);
  if (file != null) {
    Uint8List img = await file.readAsBytes();
    String urlImg = await FireStoreServices.uploadImgToStorage(user!.uid, img);
    await FirebaseAuth.instance.currentUser?.updatePhotoURL(urlImg);
    await FirebaseFirestore.instance
        .collection('doctor')
        .doc(user!.uid)
        .set({"img": urlImg});
  }
}
