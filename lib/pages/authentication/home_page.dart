import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:classtime_app/pages/classes/classes_page.dart';

class HomePage extends StatelessWidget {
  HomePage({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return ClassesPage();
  }
}
