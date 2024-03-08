import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kliniek/api/auth_fuctions.dart';
import 'package:kliniek/api/firestore_services.dart';
import 'package:kliniek/pref/appcolors.dart';

import '../api/util.dart';

class DocProfile extends StatefulWidget {
  const DocProfile({super.key});

  @override
  State<DocProfile> createState() => _DocProfileState();
}

class _DocProfileState extends State<DocProfile> {
  TextEditingController tname = TextEditingController();
  TextEditingController tfname = TextEditingController();
  TextEditingController tlname = TextEditingController();

  User? user = FirebaseAuth.instance.currentUser;
  Uint8List? image;
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    double screenwidth = MediaQuery.of(context).size.width;
    // ignore: unused_local_variable
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: AppColor().basecolor,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF3F6FA),
      body: ListView(children: [
        Center(
          child: Column(
            children: [
              StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('doctor')
                    .doc(user!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final userData =
                    snapshot.data!.data() as Map<String, dynamic>;
                    return Column(
                      children: [
                        Container(
                          width: screenwidth,
                          height: screenheight * 0.3,
                          decoration: BoxDecoration(
                              color: AppColor().basecolor,
                              borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(20),
                                  bottomRight: Radius.circular(20))),
                          child: Center(
                            child: Stack(
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
                          ),
                        ),
                        SizedBox(
                          height: screenheight * 0.025,
                        ),
                        const Text(
                          'Fullname',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: screenheight * 0.01,
                        ),
                        SizedBox(
                          width: screenwidth * 0.9,
                          child: TextFormField(
                            cursorColor: AppColor().darkcolor,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(18)),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(18)),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              filled: true,
                              fillColor: AppColor().primarycolor,
                              hintText: userData['fname'],
                              hintStyle: const TextStyle(fontSize: 14),
                            ),
                            controller: tfname,
                          ),
                        ),
                        SizedBox(
                          height: screenheight * 0.025,
                        ),
                        const Text(
                          'Lastname',
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          height: screenheight * 0.01,
                        ),
                        SizedBox(
                          width: screenwidth * 0.9,
                          child: TextFormField(
                            cursorColor: AppColor().darkcolor,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(18)),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              border: const OutlineInputBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(18)),
                                borderSide: BorderSide(
                                    color: Colors.transparent, width: 0.0),
                              ),
                              filled: true,
                              fillColor: AppColor().primarycolor,
                              hintText: userData['lname'],
                              hintStyle: const TextStyle(fontSize: 14),
                            ),
                            controller: tlname,
                          ),
                        ),
                        SizedBox(
                          height: screenheight * 0.025,
                        ),
                        SizedBox(
                          width: screenwidth * 0.4,
                          height: screenheight * 0.05,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColor().button,
                              ),
                              onPressed: () {
                                String name;
                                String fname;
                                String lname;
                                tname.text.isEmpty
                                    ? name = userData['name']
                                    : name = tname.text;
                                tfname.text.isEmpty
                                    ? fname = userData['fname']
                                    : fname = tfname.text;
                                tlname.text.isEmpty
                                    ? lname = userData['lname']
                                    : lname = tlname.text;
                                FireStoreServices.updateUserData(
                                    context, name, fname, lname, user!.uid);
                              },
                              child: const Text(
                                'Update data',
                                style: TextStyle(fontSize: 18),
                              )),
                        ),
                        SizedBox(
                          height: screenheight * 0.01,
                        ),
                        IconButton(
                          icon: const Icon(Icons.logout),
                          onPressed: () {
                            AuthServices.logOut(context);
                          },
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
                },
              ),
            ],
          ),
        ),
      ]),
    );
  }

  void selectImg() async {
    await pickImg(ImageSource.gallery, user!.uid);
  }
}
