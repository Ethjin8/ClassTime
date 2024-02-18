import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:classtime_app/pages/classes/assignments_page.dart';
import 'package:classtime_app/pages/calendar/calendar_page.dart';
import 'package:classtime_app/pages/productivity_reports/productivity_page.dart';

class ClassesPage extends StatefulWidget {
  ClassesPage({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  _ClassesPageState createState() => _ClassesPageState();
}

class _ClassesPageState extends State<ClassesPage> {
  List<String> classes = [];

  void addClass(String className) {
    setState(() {
      classes.add(className);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: widget.signUserOut,
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const SizedBox(
              height: 100,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text('Menu'),
              ),
            ),
            ListTile(
              title: const Text('Home'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ClassesPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Productivity'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProductivityPage()),
                );
              },
            ),
            ListTile(
              title: const Text('Calendar'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CalendarPage()),
                );
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: classes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(classes[index]),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      AssignmentsPage(className: classes[index])),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) {
            TextEditingController controller = TextEditingController();
            return AlertDialog(
              title: const Text('Add a class'),
              content: TextField(
                controller: controller,
                decoration: const InputDecoration(hintText: "Class name"),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Add'),
                  onPressed: () {
                    addClass(controller.text);
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
