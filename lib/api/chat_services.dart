import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../homepage/user_home.dart';

class ChatServices {
  static createChat(
      String docsId,
      String user,
      String doctor,
      String usersname,
      String id,
      String date,
      String time,
      BuildContext context) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('chatroom');
    await collectionRef
        .where('user', isEqualTo: user)
        .where('active',isEqualTo: true)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        // ignore: use_build_context_synchronously
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Already have Booking"),
                content: const Text(
                    "You already have queue\nplase check in your chat page"),
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
      } else if (value.docs.isEmpty) {
        await FirebaseFirestore.instance.collection('doctortime').doc(docsId).update({'userId':id});
        await FirebaseFirestore.instance.collection('chatroom').doc().set({
          'user': user,
          'doctor': doctor,
          'usersname': usersname,
          'time': time,
          'date': date,
          'create': FieldValue.serverTimestamp(),
          'active':true
        }).then((value) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text("Booking succese"),
                  content: const Text("Plase check in your chat page"),
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
        });
      }
    });
  }
}
