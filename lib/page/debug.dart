import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DeBug extends StatefulWidget {
  const DeBug({super.key});

  @override
  State<DeBug> createState() => _DeBugState();
}

class _DeBugState extends State<DeBug> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(Icons.logout)),
      ),
    );
  }
}
