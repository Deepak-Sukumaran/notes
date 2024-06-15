import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:notes/AddData.dart';
import 'package:notes/model.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Notes> noteList = [];
  late SharedPreferences preferences;

  getData() async {
    preferences = await SharedPreferences.getInstance();
    List<String>? stringlist = preferences.getStringList("list");

    if (stringlist != null) {
      noteList =
          stringlist.map((item) => Notes.fromMap(json.decode(item))).toList();
    }
  }

  @override
  void initState() {
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: noteList.isEmpty
          ? Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.height,
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
              child: const Center(
                  child: Text(
                "Empty",
                style: TextStyle(fontFamily: AutofillHints.addressState, fontSize: 45, color: Colors.white24),
              )))
          : Container(
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
              child: ListView.builder(
                itemCount: noteList.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.only(top: 10),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Card(
                        color: Colors.white.withOpacity(0.3),
                        shadowColor: Colors.black,
                        elevation: 25,
                        child: ListTile(
                          leading: Text(
                            "${index + 1}",
                            style: const TextStyle(color: Colors.white, fontSize: 20),
                          ),
                          title: Text(
                            noteList[index].title,
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: ReadMoreText(
                              style: const TextStyle(color: Colors.white),
                              trimMode: TrimMode.Line,
                              trimLines: 2,
                              trimCollapsedText: 'more',
                              trimExpandedText: 'Show less',
                              lessStyle: const TextStyle(
                                  color: Colors.amberAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              moreStyle: const TextStyle(
                                  color: Colors.amberAccent,
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
                              noteList[index].description),
                          trailing: IconButton(
                              onPressed: () {
                                setState(() {
                                  noteList.remove(noteList[index]);
                                  List<String> stringList = noteList
                                      .map((item) => json.encode(item.toMap()))
                                      .toList();
                                  preferences.setStringList("list", stringList);
                                });
                              },
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.white60,
                              )),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String refresh = await Navigator.push(
              context, MaterialPageRoute(builder: (context) => const AddData()));

          if (refresh == "loadData") {
            setState(() {
              getData();
            });
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
