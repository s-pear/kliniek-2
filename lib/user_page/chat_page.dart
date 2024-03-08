import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../doc_page/doc_home.dart';
import '../homepage/user_home.dart';
import '../pref/appcolors.dart';

class ChatRoom extends StatefulWidget {
  final String chatRoomId;
  final String chatRoomName;
  final String type;

  const ChatRoom({Key? key, required this.chatRoomId, required this.chatRoomName,required this.type})
      : super(key: key);

  @override
  State<ChatRoom> createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  final TextEditingController _message = TextEditingController();
  late Future<Map<String, dynamic>> docData;

  void onSendMessage() async {
    if (_message.text.isNotEmpty) {
      Map<String, dynamic> messages = {
        "sendby": FirebaseAuth.instance.currentUser!.displayName,
        "message": _message.text,
        "time": FieldValue.serverTimestamp(),
      };

      await FirebaseFirestore.instance
          .collection('chatroom')
          .doc(widget.chatRoomId)
          .collection('chats')
          .add(messages);

      _message.clear();
    }
  }

  @override
  void initState() {
    super.initState();
    docData = getData(widget.chatRoomName);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: buildAppBar(),
      backgroundColor: AppColor().bgcolor,
      body: buildChatBody(size),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      iconTheme: IconThemeData(color: AppColor().bluecolor),
      title: FutureBuilder<Map<String, dynamic>>(
        future: docData,
        builder: (context, snapshot) {
          return Text(
            snapshot.hasData ? '${snapshot.data!['fname']} ${snapshot.data!['lname']}' : 'Loading...',
            style: TextStyle(color: AppColor().bluecolor),
          );
        },
      ),
      actions: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 20),
          child: GestureDetector(
            onTap: () {
              deleteDocument(widget.chatRoomId);
            },
            child: const Icon(Icons.exit_to_app),
          ),
        )
      ],
      backgroundColor: AppColor().bgcolor,
      elevation: 0,
    );
  }

  Widget buildChatBody(Size size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          buildMessagesStream(size),
          buildMessageInput(size),
        ],
      ),
    );
  }

  Widget buildMessagesStream(Size size) {
    return SizedBox(
      height: size.height / 1.25,
      width: size.width,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatroom')
            .doc(widget.chatRoomId)
            .collection('chats')
            .orderBy('time', descending: false)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              reverse: true,
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> map = snapshot.data!
                    .docs[(snapshot.data!.docs.length - 1) - index]
                    .data() as Map<String, dynamic>;
                return buildMessage(size, map);
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  Widget buildMessageInput(Size size) {
    return Container(
      height: size.height / 10,
      width: size.width,
      alignment: Alignment.center,
      child: SizedBox(
        height: size.height / 12,
        width: size.width / 1.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildMessageTextField(),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: onSendMessage,
            )
          ],
        ),
      ),
    );
  }

  Widget buildMessageTextField() {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 1.7,
      width: MediaQuery.of(context).size.width / 1.3,
      child: TextField(
        maxLines: null,
        expands: true,
        keyboardType: TextInputType.multiline,
        controller: _message,
        decoration: InputDecoration(
          hintText: "send message",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  Widget buildMessage(Size size, Map<String, dynamic> map) {
    return Container(
      width: size.width,
      alignment: map['sendby'] == FirebaseAuth.instance.currentUser!.displayName
          ? Alignment.centerRight
          : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        constraints: BoxConstraints(maxWidth: size.width / 2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: AppColor().bluecolor,
        ),
        child: Text(
          map['message'],
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  void deleteDocument(String documentName) async {
    CollectionReference collectionRef =
    FirebaseFirestore.instance.collection('chatroom');
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("End this chat"),
          content: const Text("Do you want to end this chat?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                collectionRef.doc(documentName).update({'active':false});
                if(widget.type == "doctor") {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const UserHome()),
                          (route) => false);
                }else {
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                          builder: (context) => const LandingDoc()),
                          (route) => false);
                }
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<Map<String, dynamic>> getData(String docId) async {
    try {
      CollectionReference collection =
      FirebaseFirestore.instance.collection(widget.type);

      DocumentSnapshot documentSnapshot = await collection.doc(docId).get();

      if (documentSnapshot.exists) {
        Map<String, dynamic> data =
        documentSnapshot.data() as Map<String, dynamic>;

        return data;
      } else {
        return Map<String, dynamic>();
      }
    } catch (e) {
      return Map<String, dynamic>();
    }
  }
}
