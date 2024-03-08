import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kliniek/user_page/select_time.dart';

class Popular extends StatefulWidget {
  const Popular({Key? key}) : super(key: key);

  @override
  State<Popular> createState() => _PopularState();
}

class _PopularState extends State<Popular> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Doctor", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xFFD9E3F1),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFD9E3F1),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('doctor').snapshots(),
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
            return const Center(child: Text('No doctor right now'));
          }
          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: docs.length,
            itemBuilder: (context, index) {
              String favDocId = '${user!.uid}&${docs[index]['uid']}';

              return Padding(
                padding: const EdgeInsets.only(
                  left: 24.0,
                  right: 24,
                  bottom: 10,
                  top: 10,
                ),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                    width: screenWidth * 0.25,
                                    height: screenWidth * 0.25,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                        image: NetworkImage(docs[index]['img']),
                                        fit: BoxFit.cover,
                                      ),
                                      borderRadius: const BorderRadius.all(
                                        Radius.circular(20),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Dr. ${docs[index]['fname']} ${docs[index]['lname']}",
                                        style: const TextStyle(fontSize: 24),
                                      ),
                                      Text(
                                        '${docs[index]['catalog']}',
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                      Text(
                                        "${docs[index]['exp']} year Experience",
                                        style: const TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance
                                  .collection('fav')
                                  .doc(favDocId)
                                  .snapshots(),
                              builder: (context, snapshot) {
                                if (snapshot.hasError) {
                                  return const Text('Error loading favorites');
                                }

                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const CircularProgressIndicator();
                                }

                                if (snapshot.hasData &&
                                    snapshot.data!.exists) {
                                  return IconButton(
                                    icon: const Icon(
                                      Icons.favorite,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('fav')
                                          .doc(favDocId)
                                          .delete();
                                    },
                                  );
                                } else {
                                  return IconButton(
                                    icon: const Icon(
                                      Icons.favorite_border,
                                      color: Colors.red,
                                      size: 30,
                                    ),
                                    onPressed: () {
                                      FirebaseFirestore.instance
                                          .collection('fav')
                                          .doc(favDocId)
                                          .set({'uid': user.uid,'docId':docs[index]['uid']});
                                    },
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const SizedBox(
                                width: 20,
                              ),
                              Container(
                                margin: const EdgeInsets.only(right: 20),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(
                                        0xff778FA5), // Background color
                                  ),
                                  child: const Text(
                                    "Book Now",
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SelectTime(
                                          docId: docs[index]['uid'],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
