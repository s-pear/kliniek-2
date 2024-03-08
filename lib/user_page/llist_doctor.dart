import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kliniek/api/chat_services.dart';

import '../pref/appcolors.dart';

class ListDoctor extends StatefulWidget {
  final String catalog;
  const ListDoctor({super.key, required this.catalog});

  @override
  State<ListDoctor> createState() => _ListDoctorState();
}

class _ListDoctorState extends State<ListDoctor> {
  String datetime = DateTime.now().toString();

  String chatRoomId(String user, String doctor) {
    return "$user$doctor";
  }

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColor().bgcolor,
        appBar: AppBar(
          iconTheme: IconThemeData(color: AppColor().bluecolor),
          title: Text(
            widget.catalog,
            style: TextStyle(color: AppColor().bluecolor),
          ),
          backgroundColor: AppColor().bgcolor,
          elevation: 0,
          centerTitle: true,
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('doctor')
              .where('catalog', isEqualTo: widget.catalog)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Text('error');
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }

            var docs = snapshot.data!.docs;

            if (docs.isEmpty) {
              return const Center(child: Text('No doctor right now'));
            }
            return ListView.builder(
              itemCount: docs.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(docs[index]['img']),
                    ),
                    title: Text(
                      'Dr.${docs[index]['fname']} ${docs[index]['lname']}',
                      style: const TextStyle(fontSize: 18),
                    ),
                    onTap: () {
                      String roomId = chatRoomId(user!.uid, docs[index].id);
                    },
                  ),
                );
              },
            );
          },
        ));
  }
}
