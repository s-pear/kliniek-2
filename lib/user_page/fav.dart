import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kliniek/user_page/select_time.dart';

import '../pref/appcolors.dart';

class FavDoc extends StatefulWidget {
  const FavDoc({Key? key}) : super(key: key);

  @override
  State<FavDoc> createState() => _FavDocState();
}

class _FavDocState extends State<FavDoc> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColor().bgcolor,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Your favourite Doctors',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: const Color(0xFFAFC1D0),
        shadowColor: Colors.white,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('fav')
            .where('uid', isEqualTo: user!.uid)
            .snapshots(),
        builder: (context, favSnapshot) {
          if (favSnapshot.hasError) {
            return const Text('Error fetching favorites');
          }

          if (favSnapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          var favDocs = favSnapshot.data!.docs;

          if (favDocs.isEmpty) {
            return const Center(child: Text('No favorite doctors'));
          }

          return ListView.builder(
            scrollDirection: Axis.vertical,
            itemCount: favDocs.length,
            itemBuilder: (context, index) {
              String favDocId = '${user!.uid}&${favDocs[index]['docId']}';

              return StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('doctor')
                    .doc(favDocs[index]['docId'])
                    .snapshots(),
                builder: (context, doctorSnapshot) {
                  if (doctorSnapshot.hasError) {
                    return const Text('Error fetching doctor details');
                  }

                  if (doctorSnapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }

                  var doctorData = doctorSnapshot.data!;

                  // Ensure that the document exists before accessing its data
                  if (!doctorData.exists) {
                    return const Text('Doctor not found');
                  }

                  var docs = doctorData.data() as Map<String, dynamic>;

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
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
                                          image: NetworkImage(docs['img']),
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
                                          "Dr. ${docs['fname']} ${docs['lname']}",
                                          style: const TextStyle(fontSize: 24),
                                        ),
                                        Text(
                                          '${docs['catalog']}',
                                          style: const TextStyle(color: Colors.grey),
                                        ),
                                        Text(
                                          "${docs['exp']} year Experience",
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
                                            .set({'uid': user!.uid,'docIc':docs['uid']});
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
                                            docId: docs['uid'],
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
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
