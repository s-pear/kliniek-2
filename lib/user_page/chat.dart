import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kliniek/pref/appcolors.dart';
import 'package:intl/intl.dart';
import '../homepage/user_home.dart';
import 'chat_page.dart';

class Chat extends StatefulWidget {
  const Chat({super.key});

  @override
  State<Chat> createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  User? user = FirebaseAuth.instance.currentUser;

  String chatRoomId(String user, String doctor) {
    return "$user$doctor";
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor().bgcolor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Your chat',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: AppColor().primarycolor,
        shadowColor: Colors.white,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance
            .collection('chatroom')
            .where('user', isEqualTo: user!.uid)
            .where('active', isEqualTo: true)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('Error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          var docs = snapshot.data!.docs;

          if (docs.isEmpty) {
            return const Center(child: Text('No booking right now'));
          } else {
            String combinedDateTimeStr =
                '${docs[0]['date']} ${docs[0]['time']}';

            DateFormat dateTimeFormat = DateFormat('dd/MM/yyyy hh:mm a');
            DateTime checkTime = dateTimeFormat.parse(combinedDateTimeStr);

            return Center(
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
                padding: const EdgeInsets.all(22.0),
                margin: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    FutureBuilder(
                      future: FirebaseFirestore.instance
                          .collection('doctor')
                          .doc(docs[0]['doctor'])
                          .get(),
                      builder: (context, doctorSnapshot) {
                        if (doctorSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Text('Loading Doctor name');
                        }
                        if (doctorSnapshot.hasError) {
                          return const Text('Error fetching doctor details');
                        }

                        var doctorData = doctorSnapshot.data;
                        if (doctorData == null) {
                          return const Text('No doctor details found');
                        }

                        return Padding(
                          padding: const EdgeInsets.all(22.0),
                          child: Container(
                            child: Column(
                              children: [
                                const Text(
                                  "You have a meeting with",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 24),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: screenwidth * 0.3,
                                    height: screenwidth * 0.3,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(
                                          doctorData['img'],
                                        ),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(100),
                                      ),
                                    ),
                                  ),
                                ),
                                Text(
                                  "Dr.${doctorData['fname']} ${doctorData['lname']}",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(fontSize: 32),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    Text(
                      "On\n${docs[0]['date']}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22),
                    ),
                    Text(
                      "At\n${docs[0]['time']}",
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 22),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: screenwidth * 0.3,
                          height: screenheight * 0.07,
                          child: ElevatedButton(
                            onPressed: () {
                              CollectionReference collectionRef =
                              FirebaseFirestore.instance.collection('chatroom');
                              collectionRef.doc(docs[0].id).update({'active':false});
                              Navigator.of(context).pushAndRemoveUntil(
                                  MaterialPageRoute(
                                      builder: (context) => const UserHome()),
                                      (route) => false);
                            },
                            child: const Text("Cancel"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: screenwidth * 0.3,
                          height: screenheight * 0.07,
                          child: ElevatedButton(
                            onPressed: () {
                              if (checkTime.isBefore(DateTime.now())){
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChatRoom(chatRoomId: docs[0].id,chatRoomName: docs[0]['doctor'],type: "doctor")));
                              }else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Please wait until booking time')));
                              }
                            },
                            child: const Text("Go to chat"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: checkTime.isBefore(DateTime.now())
                                  ? Colors.blue
                                  : AppColor().basecolor,
                            ),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
