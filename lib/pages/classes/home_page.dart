import 'package:classtime_app/components/assignments_tile.dart';
import 'package:classtime_app/pages/authentication/auth_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:classtime_app/pages/calendar/calendar_page.dart';
import 'package:classtime_app/pages/productivity_reports/productivity_page.dart';
import 'package:classtime_app/pages/classes/add_assignments_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser!;
  String searchQuery = '';
  late FocusNode _searchFocusNode;

  @override
  void initState() {
    super.initState();
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchFocusNode.dispose();
    super.dispose();
  }

  void signUserOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const AuthPage()),
    );
  }

  final Stream<QuerySnapshot> _stream =
      FirebaseFirestore.instance.collection("Assignments").snapshots();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // When tapped outside, remove focus from search bar
        _searchFocusNode.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "Schedule",
            style: TextStyle(
              fontSize: 34,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
          actions: [
            IconButton(
              onPressed: signUserOut,
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
                    color: Colors.grey,
                  ),
                  child: Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              ListTile(
                title: const Text('Home'),
                onTap: () {
                  Navigator.pop(context);
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
                    MaterialPageRoute(
                        builder: (context) => const CalendarPage()),
                  );
                },
              ),
            ],
          ),
        ),
        backgroundColor: Colors.black87,
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0.0),
              child: StreamBuilder(
                stream: _stream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  final docs = snapshot.data!.docs;
                  final groupedDocs = groupBy(docs,
                      (doc) => (doc.data() as Map<String, dynamic>)['dueDate']);

                  List<Widget> assignmentWidgets = [];
                  List<MapEntry<String, List<DocumentSnapshot>>> entries =
                      groupedDocs.entries
                          .map((e) => MapEntry<String, List<DocumentSnapshot>>(
                              e.key.toString(), e.value))
                          .toList();

                  entries.sort((a, b) => a.key.compareTo(b.key));

                  String formatDate(String date) {
                    DateTime dateTime = DateTime.parse(date);
                    DateTime now = DateTime.now();
                    if (dateTime.year == now.year &&
                        dateTime.month == now.month &&
                        dateTime.day == now.day) {
                      return "Today";
                    } else if (dateTime.isBefore(now)) {
                      return "Past";
                    } else {
                      return "Future";
                    }
                  }

                  Map<String, List<MapEntry<String, List<DocumentSnapshot>>>>
                      sortedEntries = {
                    "Today": [],
                    "Future": [],
                    "Past": [],
                  };

                  for (var entry in entries) {
                    sortedEntries[formatDate(entry.key)]!.add(entry);
                  }

                  sortedEntries.forEach((key, value) {
                    if (value.isNotEmpty) {
                      assignmentWidgets.add(Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: ShaderMask(
                                shaderCallback: (bounds) {
                                  if (key == "Future") {
                                    return LinearGradient(
                                      colors: [
                                        Colors.yellow[700]!,
                                        Colors.green
                                      ],
                                      tileMode: TileMode.mirror,
                                    ).createShader(bounds);
                                  } else if (key == "Today") {
                                    return LinearGradient(
                                      colors: [Colors.red, Colors.orange],
                                      tileMode: TileMode.mirror,
                                    ).createShader(bounds);
                                  } else {
                                    return LinearGradient(
                                      colors: [Colors.blue, Colors.purple],
                                      tileMode: TileMode.mirror,
                                    ).createShader(bounds);
                                  }
                                },
                                child: Text(
                                  key,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            ...value.map((entry) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 8.0,
                                        bottom:
                                            4.0), // This is where the code goes
                                    child: Text(
                                      DateFormat('MMMM dd').format(
                                          DateTime.parse(
                                              entry.key)), // Format the date
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  ...entry.value.map((doc) {
                                    Map<String, dynamic> data =
                                        doc.data() as Map<String, dynamic>;
                                    return AssignmentsTile(
                                      title: data['title'] ?? "Untitled",
                                      time: data['dueTime'],
                                      documentID: doc.id,
                                    );
                                  }).toList(),
                                ],
                              );
                            }).toList(),
                          ],
                        ),
                      ));
                    }
                  });

                  return Center(
                    child: ListView(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            focusNode: _searchFocusNode,
                            onChanged: (value) {
                              setState(() {
                                searchQuery = value;
                              });
                            },
                            style: const TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                            ),
                            decoration: InputDecoration(
                              hintText: 'Find an assignment',
                              hintStyle: const TextStyle(color: Colors.white),
                              prefixIcon: Container(
                                padding: const EdgeInsets.only(
                                    left: 8.0,
                                    right: 12.0), // Adjust padding here
                                child: const Icon(Icons.search,
                                    color: Colors.white),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              border: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide:
                                    const BorderSide(color: Colors.white),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ),
                        if (assignmentWidgets.isEmpty)
                          const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.error_outline_rounded,
                                    size: 60.0, color: Colors.white),
                                SizedBox(height: 10.0),
                                Text(
                                  'No assignments found',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ],
                            ),
                          )
                        else
                          ...assignmentWidgets,
                        const Padding(
                          padding: EdgeInsets.only(bottom: 70.0),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: AddAssignmentsButton(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget AddAssignmentsButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.all(30.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AssignmentsPage()),
            );
          },
          child: Container(
            height: 52,
            width: 52,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Colors.indigoAccent,
                  Colors.purple,
                ],
              ),
            ),
            child: const Icon(Icons.add, color: Colors.white), // Plus sign
          ),
        ),
      ),
    );
  }
}
