import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../api/chat_services.dart';

class SelectTime extends StatefulWidget {
  final String docId;
  const SelectTime({super.key, required this.docId});

  @override
  State<SelectTime> createState() => _SelectTimeState();
}

class _SelectTimeState extends State<SelectTime> {
  List months =
  ['JAN', 'FEB', 'MAR', 'APR', 'MAY','JUN','JUL','AUG','SEP','OCT','NOV','DEC'];

  int todayDate = DateTime.now().day;
  int todayMonth = DateTime.now().month;
  int todayYear = DateTime.now().year;
  int selectDate = DateTime.now().day;

  int nowtime = 0;
  int nowdate = 0;

  User? user = FirebaseAuth.instance.currentUser;


  @override
  Widget build(BuildContext context) {
    double screenwidth = MediaQuery.of(context).size.width;
    double screenheight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Time", style: TextStyle(color: Colors.black)),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: const Color(0xFFD9E3F1),
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFD9E3F1),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
          .collection('doctor')
          .doc(widget.docId)
          .snapshots(),
        builder: (context, snapshot) {
          if(!snapshot.hasData){
            return const Center(
              child: Text("NO DATA FOUND")
            );
          }
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final userData =
          snapshot.data!.data() as Map<String, dynamic>;
          return Center(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    height: screenheight * 0.15,
                    width: screenwidth * 0.9,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20,right: 20),
                          width: screenwidth * 0.2,
                          height: screenwidth * 0.2,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(userData['img']),
                                  fit: BoxFit.cover),
                              borderRadius: const BorderRadius.all(Radius.circular(20))),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dr.${userData['fname']} ${userData['lname']}",
                              style: const TextStyle(fontSize: 20),
                            ),
                            Text(
                              "${userData['catalog']}",
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: SizedBox(
                    height: screenheight * 0.1, // card height
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 7,
                      itemBuilder: (_, k) {
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectDate = todayDate + k;
                                  nowdate = k;
                                });
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                      color: k == nowdate
                                          ? const Color(0xff778FA5)
                                          : Colors.white,
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10))),
                                  width: screenwidth * 0.3,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '${todayDate + k} ${months[todayMonth-1]}',
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: k == nowdate
                                                  ? Colors.white
                                                  : Colors.black),
                                        )
                                      ],
                                    ),
                                  )),
                            ));
                      },
                    ),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(20),
                  child: Text("Available time at \n$selectDate/$todayMonth/$todayYear",textAlign: TextAlign.center,style: const TextStyle(fontSize: 18)),
                ),
                SizedBox(
                  width: screenwidth*0.9,
                  height: screenheight*0.5,
                  child: StreamBuilder(stream: FirebaseFirestore.instance
                      .collection('doctortime')
                      .where('docId',isEqualTo: widget.docId)
                      .where('date',isEqualTo:"$selectDate/$todayMonth/$todayYear")
                      .snapshots(),
                      builder: (context , snapshot) {
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
                          return const Center(child: Text('No available time today'));
                        }
                        return ListView.builder(
                            itemCount: docs.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: () {
                                  if (docs[index]['userId'] == "") {
                                    String roomId = chatRoomId(user!.uid, docs[index]['docId']);
                                    ChatServices.createChat(
                                        docs[index].id,
                                        user!.uid,
                                        docs[index]['docId'],
                                        user!.displayName!,
                                        roomId,
                                        docs[index]['date'],
                                        docs[index]['time'],
                                        context);
                                  }else{
                                    showDialog(context: context,
                                        builder: (BuildContext context) {
                                         return AlertDialog(
                                            title: const Text("You Can't Booking This Time"),
                                            content: const Text("Select new time"),
                                            actions: [
                                              TextButton(
                                                child: const Text("OK"),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              )
                                            ],
                                          );
                                        }
                                    );
                                  }
                                },
                                child: Container(
                                  margin: EdgeInsets.only(top: 20),
                                  decoration: BoxDecoration(
                                      color: docs[index]['userId'] == "" ? Colors.green : Colors.red,
                                      borderRadius: const BorderRadius.all(Radius.circular(20))
                                  ),
                                  width: screenwidth*0.9,
                                  height: screenheight*0.1,
                                  child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        Text('${docs[index]['time']}',style: const TextStyle(fontSize: 24,color: Colors.white),),
                                        docs[index]['userId'] == "" ? const Text("available",style: TextStyle(fontSize: 22,color: Colors.white)): const Text("unavailable",style: TextStyle(fontSize: 22,color: Colors.white)),
                                      ],
                                    )
                                  ),
                                )
                              );
                            }
                        );
                      }
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
  String chatRoomId(String user, String doctor) {
    return "$user$doctor";
  }
}
