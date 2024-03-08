import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../homepage/user_home.dart';

class FireStoreServices {
  static saveUser(String name, String email, uid, String role) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .set({'name': name, 'role': role, 'email': email});
  }

  static Future<String> uploadImgToStorage(
      String fileName, Uint8List file) async {
    final path = 'photoimg/$fileName';
    Reference ref = FirebaseStorage.instance.ref().child(path);
    UploadTask uploadTask = ref.putData(file);
    TaskSnapshot snapshot = await uploadTask;
    String imgUrl = await snapshot.ref.getDownloadURL();
    return imgUrl;
  }

  static addDoctor(String name, String lname, String exp, String catalog, uid,
      String imageUrl) async {
    await FirebaseFirestore.instance.collection('doctor').doc(uid).set({
      'fname': name,
      'lname': lname,
      'exp': exp,
      'catalog': catalog,
      'uid': uid,
      'img': imageUrl
    });
  }

  static updateUserData(
    BuildContext context,
    String name,
    String fname,
    String lname,
    uid,
  ) async {
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'name': name,
      'fname': fname,
      'lname': lname,
      'role': 'user',
    });
    FirebaseAuth.instance.currentUser!.updateDisplayName(name);
    // ignore: use_build_context_synchronously
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Update data succese"),
            content: const Text("plase check in your profile page"),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                            builder: (context) => const UserHome()),
                        (route) => false);
                  },
                  child: const Text('OK'))
            ],
          );
        });
  }
}
