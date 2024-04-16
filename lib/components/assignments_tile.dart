// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class AssignmentsTile extends StatefulWidget {
  final String title;
  final String time;
  final String documentID;

  const AssignmentsTile({
    Key? key,
    required this.title,
    required this.time,
    required this.documentID,
  }) : super(key: key);

  @override
  _AssignmentsTileState createState() => _AssignmentsTileState();
}

class _AssignmentsTileState extends State<AssignmentsTile> {
  bool check = false;
  String title = '';
  String type = '';
  String subject = '';
  String priority = '';
  String description = '';
  String dueDate = '';
  String dueTime = '';
  String timeNeeded = '';

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchAssignmentDetails().then((_) {
      setState(() {
        isLoading =
            false; // Set isLoading to false when fetchAssignmentDetails completes
      });
    });
  }

  fetchAssignmentDetails() async {
    DocumentSnapshot document = await FirebaseFirestore.instance
        .collection("Assignments")
        .doc(widget.documentID)
        .get();
    setState(() {
      check = document.get('check') ?? false;
      title = document.get('title') ?? '';
      type = document.get('taskType') ?? '';
      subject = document.get('subject') ?? '';
      priority = document.get('priority') ?? '';
      description = document.get('description') ?? '';
      dueDate = document.get('dueDate') ?? '';
      dueTime = document.get('dueTime') ?? '';
      timeNeeded = document.get('timeNeeded') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Center(
              child: AlertDialog(
                title: Center(child: Text(widget.title)),
                content: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minHeight: 100, // Adjust minimum height here
                      maxHeight: MediaQuery.of(context).size.height *
                          0.33, // Adjust maximum height here
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Type: $type'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Subject: $subject'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Priority: $priority'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Description: $description'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Due Date: $dueDate'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Due Time: $dueTime'),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text('Time Needed: $timeNeeded'),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
      child: SizedBox(
        width: MediaQuery.of(context).size.width, // Adjust the width here
        child: Slidable(
          endActionPane: ActionPane(
            motion: const StretchMotion(),
            children: [
              SlidableAction(
                onPressed: (context) => FirebaseFirestore.instance
                    .collection("Assignments")
                    .doc(widget.documentID)
                    .delete(),
                icon: Icons.delete,
                backgroundColor: Colors.red.shade300,
                borderRadius: BorderRadius.circular(12),
              )
            ],
          ),
          child: Row(
            children: [
              Theme(
                child: Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    activeColor: const Color(0xff6cf8a9),
                    checkColor: const Color(0xff0e3e26),
                    value: check,
                    onChanged: (bool? value) {
                      setState(() {
                        check = value!;
                      });
                      FirebaseFirestore.instance
                          .collection("Assignments")
                          .doc(widget.documentID)
                          .update({'check': check});
                    },
                  ),
                ),
                data: ThemeData(
                  primarySwatch: Colors.blue,
                  unselectedWidgetColor: const Color(0xff5e616a),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: 75,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: const Color(0xff2a2e3d),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const SizedBox(
                          width: 12,
                        ),
                        Expanded(
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 18,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            widget.time,
                            style: const TextStyle(
                              fontSize: 18,
                              letterSpacing: 1,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 12,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
