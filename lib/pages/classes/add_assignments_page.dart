// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignmentsPage extends StatefulWidget {
  const AssignmentsPage({super.key});

  @override
  _AssignmentsPageState createState() => _AssignmentsPageState();
}

class _AssignmentsPageState extends State<AssignmentsPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String taskType = "";
  String subjectType = "";
  String priority = "";
  final TextEditingController _dateController = TextEditingController();
  TimeOfDay selectedTime = TimeOfDay.now();
  double _currentSliderValue = 0;

  String selectedPriority = "";
  String? selectedTaskType;
  String value = '';
  var taskTypes = [
    'Essay',
    'Project',
    'Notes',
    'Practice Probems',
    'Progress Check',
  ];

  String? selectedClassType;
  String val = '';
  var subjectTypes = [
    'Math',
    'Chemistry',
    'History',
    'English',
    'Psychology',
    'Physics',
    'Drawing'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xff1d1e26),
              Color(0xff252041),
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 50),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: Icon(
                  CupertinoIcons.arrow_left,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Text(
                      "Create Assignment",
                      style: TextStyle(
                        fontSize: 35,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 4,
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    label("Assignment Title"),
                    SizedBox(
                      height: 12,
                    ),
                    title(),
                    SizedBox(
                      height: 30,
                    ),
                    label("Assignment Type"),
                    SizedBox(
                      height: 12,
                    ),
                    typeSelect(),
                    SizedBox(
                      height: 30,
                    ),
                    label("Subject"),
                    SizedBox(
                      height: 12,
                    ),
                    subjectSelect(),
                    SizedBox(
                      height: 30,
                    ),
                    label("Priority"),
                    SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        prioritySelect("High"),
                        prioritySelect("Medium"),
                        prioritySelect("Low"),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    label("Description"),
                    SizedBox(
                      height: 12,
                    ),
                    description(),
                    SizedBox(
                      height: 30,
                    ),
                    label("Due Date"),
                    SizedBox(
                      height: 12,
                    ),
                    dateSelect(),
                    SizedBox(
                      height: 30,
                    ),
                    label("Due Time"),
                    SizedBox(
                      height: 12,
                    ),
                    timePicker(),
                    SizedBox(
                      height: 30,
                    ),
                    label("Time Needed (Hours)"),
                    SizedBox(
                      height: 12,
                    ),
                    estimatedHours(),
                    SizedBox(
                      height: 30,
                    ),
                    AddAssignmentButton(),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget title() {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _titleController,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: "Title",
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 20,
            right: 20,
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a title';
          }
          return null;
        },
      ),
    );
  }

  Widget label(String label) {
    return Text(
      label,
      style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 16.5,
        letterSpacing: 0.2,
      ),
    );
  }

  Widget typeSelect() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 70, // Increase the height
          width: 200,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            dropdownColor: Colors.white,
            items: taskTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(child: Text(value)), // Center the text
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedTaskType = newValue;
                taskType = newValue ?? "";
              });
            },
            value: selectedTaskType,
            icon: Icon(Icons.arrow_drop_down), // Add a dropdown arrow
            iconEnabledColor: Colors.black, // Change the color of the arrow
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a task type';
              }
              return null;
            },
          ),
        ),
      ),
    );
  }

  Widget subjectSelect() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          height: 70, // Increase the height
          width: 200,
          child: DropdownButtonFormField<String>(
            isExpanded: true,
            dropdownColor: Colors.white,
            items: subjectTypes.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Center(child: Text(value)), // Center the text
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedClassType = newValue;
                subjectType = newValue ?? "";
              });
            },
            value: selectedClassType,
            icon: Icon(Icons.arrow_drop_down), // Add a dropdown arrow
            iconEnabledColor: Colors.black, // Change the color of the arrow
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget prioritySelect(String label) {
    return InkWell(
      onTap: () {
        setState(() {
          selectedPriority = label;
        });
      },
      child: Chip(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        backgroundColor:
            selectedPriority == label ? Color(0xff2664fa) : Color(0xff1d1e26),
        label: Text(label),
        labelStyle: TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
        labelPadding: EdgeInsets.symmetric(horizontal: 17, vertical: 3.8),
      ),
    );
  }

  Widget dateSelect() {
    return Container(
      height: 60, // Increase the height
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.white, // Set the background color to full white
        borderRadius: BorderRadius.circular(15),
      ),
      padding: EdgeInsets.all(4.0), // Add some padding
      child: TextField(
        controller: _dateController,
        style: TextStyle(
          color: Colors.black,
          fontSize: 17,
        ),
        decoration: InputDecoration(
          border: InputBorder.none, // Remove the border
          labelText: 'DUE DATE',
          filled: true,
          fillColor: Colors.white, // Set the fillColor to white
          prefixIcon: Icon(Icons.calendar_today, color: Colors.black),
          hintStyle: TextStyle(
            color: Colors.grey,
            fontSize: 17,
          ),
          contentPadding: EdgeInsets.only(
            left: 30, // Increase left padding
            right: 30, // Increase right padding
            top: 3, // Decrease top padding
            bottom: 15, // Increase bottom padding
          ),
        ),
        readOnly: true,
        onTap: () {
          _showDatePicker();
        },
      ),
    );
  }

  Future<void> _showDatePicker() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateController.text.isEmpty
          ? DateTime.now()
          : DateTime.parse(_dateController.text),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = picked.toString().split(" ")[0];
      });
    } else {
      setState(() {
        _dateController.text = DateTime.now().toString().split(" ")[0];
      });
    }
  }

  Widget timePicker() {
    return GestureDetector(
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: selectedTime,
        );

        if (pickedTime != null) {
          setState(() {
            selectedTime = pickedTime;
          });
        }
      },
      child: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
        ),
        padding: EdgeInsets.all(4.0),
        child: AbsorbPointer(
          child: TextField(
            style: TextStyle(
              color: Colors.black,
              fontSize: 17,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              labelText: 'DUE TIME',
              filled: true,
              fillColor: Colors.white,
              prefixIcon: Icon(Icons.access_time, color: Colors.black),
              hintStyle: TextStyle(
                color: Colors.grey,
                fontSize: 17,
              ),
              contentPadding: EdgeInsets.only(
                left: 30,
                right: 30,
                top: 3,
                bottom: 15,
              ),
            ),
            readOnly: true,
            controller:
                TextEditingController(text: selectedTime.format(context)),
          ),
        ),
      ),
    );
  }

  Widget estimatedHours() {
    return Slider(
      value: _currentSliderValue,
      max: 24,
      divisions: 240,
      label: _currentSliderValue.toStringAsFixed(2),
      onChanged: (double value) {
        setState(() {
          _currentSliderValue = value;
        });
      },
    );
  }

  Widget AddAssignmentButton() {
    return InkWell(
      onTap: () {
        FirebaseFirestore.instance.collection("Assignments").add({
          "title": _titleController.text,
          "taskType": taskType,
          "priority": selectedPriority,
          "description": _descriptionController.text,
          "dueDate": _dateController.text,
          "dueTime": selectedTime.format(context),
          "subject": subjectType,
          "timeNeeded": _currentSliderValue.toString(),
        }).then((value) {
          Navigator.pop(context);
        });
      },
      child: Container(
        height: 56,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            colors: const [
              Color(0xff2664fa),
              Color(0xffad32f9),
            ],
          ),
        ),
        child: Center(
          child: Text(
            "Add Assignment",
            style: TextStyle(
              color: Colors.white,
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget description() {
    return Container(
      height: 150,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Color(0xff2a2e3d),
        borderRadius: BorderRadius.circular(15),
      ),
      child: TextFormField(
        controller: _descriptionController,
        style: TextStyle(
          color: Colors.grey,
          fontSize: 17,
        ),
        maxLines: null,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Write your description here",
            hintStyle: TextStyle(
              color: Colors.grey,
              fontSize: 17,
            ),
            contentPadding: EdgeInsets.only(
              left: 20,
              right: 20,
            )),
      ),
    );
  }
}
