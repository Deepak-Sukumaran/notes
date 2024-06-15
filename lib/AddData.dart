// ignore_for_file: file_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:notes/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddData extends StatefulWidget {
  const AddData({super.key});

  @override
  State<AddData> createState() => _AddDataState();
}

class _AddDataState extends State<AddData> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<Notes> noteList = [];

  late SharedPreferences preferences;

  void getData() async {
    preferences = await SharedPreferences.getInstance();
    List<String>? stringList = preferences.getStringList("list");

    if (stringList != null) {
      noteList = stringList
          .map(
            (e) => Notes.fromMap(json.decode(e)),
          )
          .toList();
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //   appBar: AppBar(elevation: 0, flexibleSpace: Container( decoration: BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topLeft,
      //       end: Alignment.bottomRight,
      //       colors: [
      //         Colors.blue, // Start color
      //         Colors.blue, // End color
      //         Colors.blueAccent, // End color
      //         Colors.blueAccent, // End color
      //       ],
      //     ),
      //   ),
      // ),),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue, // Start color
              Colors.red, // End color
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15, top: 35),
                child: TextField(
                  cursorColor: Colors.redAccent,
                  controller: titleController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                  style: const TextStyle(
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  decoration: const InputDecoration(
                      hintText: "Title",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white54)),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextField(
                  cursorColor: Colors.redAccent,
                  keyboardType: TextInputType.multiline,
                  controller: descriptionController,
                  maxLines: 200,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                  ),
                  decoration: const InputDecoration(
                      hintText: "Description",
                      border: InputBorder.none,
                      hintStyle: TextStyle(color: Colors.white54)),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Save action here

          noteList.insert(
              0,
              Notes(
                  title: titleController.text,
                  description: descriptionController.text));
          List<String> stringList = noteList
              .map(
                (e) => jsonEncode(e.toMap()),
              )
              .toList();
          preferences.setStringList("list", stringList);
          Navigator.pop(context, "loadData");
        },
        child: const Text("Save"),
      ),
    );
  }
}
