import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kliniek/api/util.dart';
import 'package:kliniek/page/doctor_register.dart';
import 'package:kliniek/pref/appcolors.dart';
import '../user_page/chat_page.dart';

class DoctorHome extends StatefulWidget {
  final bool isCheck;
  const DoctorHome({super.key, required this.isCheck});

  @override
  State<DoctorHome> createState() => _DoctorHomeState();
}

class _DoctorHomeState extends State<DoctorHome> {
  bool hasdata = false;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (widget.isCheck == true) {
      hasdata = true;
    } else {
      findDocument(user!.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    if (hasdata == false) {
      return Scaffold(
        backgroundColor: AppColor().bgcolor,
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/Doctor1.png',
              width: screenwidth * 0.8,
            ),
            SizedBox(height: screenheight * 0.025),
            const Text(
              'First time use please fill information',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: screenheight * 0.025),
            SizedBox(
              width: screenwidth * 0.6,
              height: screenheight * 0.07,
              child: TextButton(
                style: TextButton.styleFrom(
                    backgroundColor: AppColor().darkcolor,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    )),
                child: Text(
                  'Tap to continue',
                  style:
                      TextStyle(color: AppColor().primarycolor, fontSize: 20),
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const DoctorRegister()));
                },
              ),
            ),
          ],
        )),
      );
    } else {
      return Scaffold(
        backgroundColor: AppColor().bgcolor,
        body: Center(
          child: Column(
            children: [
              Container(
                height: screenheight * 0.3,
                width: screenwidth,
                decoration: BoxDecoration(
                    color: AppColor().basecolor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('doctor')
                        .doc(user!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              'Hello Dr.\n   ${userData['fname']} \n      ${userData['lname']}',
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 24, color: AppColor().whitecolor),
                            ),
                            Stack(
                              children: [
                                userData['img'] == null
                                    ? const CircleAvatar(
                                        radius: 64,
                                        backgroundImage: NetworkImage(
                                            'https://firebasestorage.googleapis.com/v0/b/kliniek-app.appspot.com/o/user.png?alt=media&token=77f2f379-5deb-46c6-9eac-e7f0c0d637e6'),
                                      )
                                    : CircleAvatar(
                                        radius: 64,
                                        backgroundImage:
                                            NetworkImage(userData['img']),
                                      ),
                                Positioned(
                                  bottom: -10,
                                  left: 80,
                                  child: IconButton(
                                    onPressed: () {
                                      selectImg();
                                    },
                                    icon: const Icon(Icons.add_a_photo),
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error ${snapshot.error}'));
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ),
              SizedBox(
                height: screenheight * 0.025,
              ),
              const SizedBox(
                child: Text('This is your case',style: TextStyle(fontSize: 18)),
              ),
              SizedBox(
                height: screenheight * 0.5,
                width: screenwidth * 0.95,
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('chatroom')
                      .where('doctor', isEqualTo: user!.uid).where('active',isEqualTo: true)
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
                      return const Center(child: Text('No chat right now',style: TextStyle(fontSize: 18)));
                    }
                    return ListView.builder(
                      itemCount: docs.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            CollectionReference collectionRef =
                            FirebaseFirestore.instance.collection('chatroom');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ChatRoom(
                                  chatRoomId: docs[index].id,
                                  chatRoomName: docs[index]['user'],
                                  type: "users",
                                )));
                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                    "Date: ${docs[index]['date']} Time: ${docs[index]['time']}",style: TextStyle(fontSize: 18),),
                                const Text("with",style: TextStyle(fontSize: 16)),
                                FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(docs[index]['user'])
                                        .get(),
                                    builder: (context, usersnapshot) {
                                      if (usersnapshot.hasError) {
                                        return const Text('Error');
                                      }

                                      if (usersnapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      var dataUser = usersnapshot.data!.data()!;

                                      return Row(
                                        children: [
                                          dataUser['img'] == null
                                              ? const CircleAvatar(
                                            radius: 48,
                                            backgroundImage: NetworkImage(
                                                'https://firebasestorage.googleapis.com/v0/b/kliniek-app.appspot.com/o/user.png?alt=media&token=77f2f379-5deb-46c6-9eac-e7f0c0d637e6'),
                                          )
                                              : CircleAvatar(
                                            radius: 48,
                                            backgroundImage:
                                            NetworkImage(dataUser['img']),
                                          ),
                                          SizedBox(width: 20,),
                                          Text('${dataUser['fname']} ${dataUser['lname']}',style: TextStyle(fontSize: 18))
                                        ],
                                      );
                                    })
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            ],
          ),
        ),
      );
    }
  }

  void selectImg() async {
    await pickImgDoc(ImageSource.gallery, user!.uid);
  }

  void findDocument(String documentName) async {
    CollectionReference collectionRef =
        FirebaseFirestore.instance.collection('doctor');

    QuerySnapshot querySnapshot = await collectionRef
        .where(FieldPath.documentId, isEqualTo: documentName)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      setState(() {
        hasdata = true;
      });
    } else {
      setState(() {
        hasdata = false;
      });
    }
  }
}


