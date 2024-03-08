import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kliniek/pref/appcolors.dart';
import 'package:kliniek/user_page/choose_doctor.dart';
import 'package:kliniek/user_page/find_doctor.dart';
import 'package:kliniek/user_page/llist_doctor.dart';
import 'package:kliniek/user_page/pp_doc.dart';
import 'package:kliniek/user_page/select_time.dart';

class MainHome extends StatefulWidget {
  const MainHome({Key? key}) : super(key: key);

  @override
  State<MainHome> createState() => _MainHomeState();
}

class _MainHomeState extends State<MainHome> {
  User? user = FirebaseAuth.instance.currentUser;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColor().bgcolor,
      body: ListView(
        shrinkWrap: true,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: screenwidth,
                height: screenheight * 0.2,
                decoration: BoxDecoration(
                  color: AppColor().primarycolor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('users')
                        .doc(user!.uid)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final userData =
                            snapshot.data!.data() as Map<String, dynamic>;
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hi' ${userData['fname']} ${userData['lname']}",
                                    style: const TextStyle(
                                        fontSize: 24, color: Colors.black),
                                    textAlign: TextAlign.start,
                                  ),
                                  const Text(
                                    "Find Your Doctor",
                                    style: TextStyle(
                                        fontSize: 30, color: Colors.black),
                                    textAlign: TextAlign.start,
                                  )
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  userData['img'] == null
                                      ? const CircleAvatar(
                                          radius: 42,
                                          backgroundImage: NetworkImage(
                                              'https://firebasestorage.googleapis.com/v0/b/kliniek-app.appspot.com/o/user.png?alt=media&token=77f2f379-5deb-46c6-9eac-e7f0c0d637e6'),
                                        )
                                      : CircleAvatar(
                                          radius: 42,
                                          backgroundImage:
                                              NetworkImage(userData['img']),
                                        ),
                                ],
                              )
                            ],
                          ),
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
              Positioned(
                bottom: -35,
                left: 40,
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const FindDoctor()));
                  },
                  child: Container(
                    decoration: const BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black,
                          offset: Offset(0.0, 5.0),
                          blurRadius: 5.0,
                          spreadRadius: 0.5,
                        ),
                      ],
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                    ),
                    width: screenwidth * 0.8,
                    height: screenheight * 0.075,
                    child: const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          SizedBox(
                            child: Row(
                              children: [Icon(Icons.search), Text("Search...")],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SizedBox(
              height: 150, // card height
              child: PageView.builder(
                itemCount: 10,
                controller: PageController(viewportFraction: 0.3),
                onPageChanged: (int index) => setState(() => _index = index),
                itemBuilder: (_, i) {
                  return Transform.scale(
                    scale: i == _index ? 1 : 0.9,
                    child: Card(
                      shadowColor: Colors.transparent,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:
                          const Center(child: Icon(Icons.play_arrow_rounded)),
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25.0),
            child: Container(
                padding: const EdgeInsets.all(15),
                width: screenwidth,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Catalog",style: TextStyle(fontSize: 26),),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const ChooseDoctor()));
                      },
                      child: const Text("See all>",
                          style: TextStyle(
                              fontSize: 18, color: Colors.black)),
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: screenheight * 0.15, // card height
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 9,
              itemBuilder: (_, j) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: iconImg('assets/${j + 1}.png', j),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              width: screenwidth,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "All doctor",
                    style: TextStyle(fontSize: 26),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const Popular()));
                    },
                    child: const Text(
                      "See all>",
                      style: TextStyle(fontSize: 18, color: Colors.black),
                    ),
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10),
             child: SizedBox(

               height: screenheight * 0.3,
               child: StreamBuilder(
               stream: FirebaseFirestore.instance
                .collection('doctor')
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
                  scrollDirection: Axis.horizontal,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => SelectTime(docId: docs[index]['uid'],)));
                          },
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            width: screenheight * 0.25,
                            height: screenheight * 0.25,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(22))
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundImage: NetworkImage(docs[index]['img']),
                                  radius: 52,
                                ),
                                Container(
                                  margin: const EdgeInsets.all(18),
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Text("Dr.${docs[index]['fname']} ${docs[index]['lname']}",style: const TextStyle(fontSize: 32,color: Colors.black),),
                                        Text("${docs[index]['catalog']}",style: const TextStyle(fontSize: 18,color: Colors.black),)
                                      ],
                                    ),
                                  )
                                )
                              ],
                            ),
                          ),
                        )
                    );
                  },
                );
            }
            ),
             ),
          )
        ],
      ),
    );
  }

  Widget iconImg(String asset, int page) {
    List<String> docType = ['General','Pediattrics','Cardiology','Ophthalmology','Obstetrics','Elderly care','Dentistry','Otolaryngology','Office syndrome'];
    double screenwidth = MediaQuery.of(context).size.width;
    return Material(
      color: Colors.white,
      elevation: 8,
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: InkWell(
        splashColor: Colors.black,
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => ListDoctor(catalog: docType[page])));
        },
        child: Ink.image(
          image: AssetImage(asset),
          width: screenwidth * 0.25,
          height: screenwidth * 0.25,
        ),
      ),
    );
  }
}
