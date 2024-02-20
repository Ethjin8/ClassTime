import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:classtime_app/components/dialog_box.dart';
import 'package:classtime_app/components/assignments_tile.dart';

class AssignmentsPage extends StatefulWidget {
  final String className;

  AssignmentsPage({Key? key, required this.className}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser!;
  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  _AssignmentsPageState createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  final _controller = TextEditingController();

  List assignmentsList = [
    ["Add an assignment to get started! \nSwipe right to delete this tile", false],
  ];

  void checkBoxChanged(bool? value, int index) {
    setState(() {
      assignmentsList[index][1] = assignmentsList[index][1];
    });
  }

  void saveNewTask() {
    setState(() {
      assignmentsList.add([_controller.text, false]);
      _controller.clear();
    });
    Navigator.of(context).pop();
  }

  void createNewTask() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller: _controller,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );
      },
    );
  }

  void deleteTask(int index) {
    setState(() {
      assignmentsList.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.className),
          backgroundColor: Colors.blue.shade100,
          elevation: 15,
        ),
        backgroundColor: Color.fromARGB(188, 25, 147, 246),
        floatingActionButton: FloatingActionButton(
          onPressed: createNewTask,
          child: const Icon(Icons.add),
        ),
        body: ListView.builder(
          itemCount: assignmentsList.length,
          itemBuilder: (context, index) {
            return AssignmentsTile(
              taskName: assignmentsList[index][0],
              taskCompleted: assignmentsList[index][1],
              onChanged: (value) => checkBoxChanged(value, index),
              deleteFunction: (context) => deleteTask(index),
            );
          },
        ));
  }
}
