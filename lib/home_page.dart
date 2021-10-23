import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_count_down/countdown.dart';
import 'package:event/home_add_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:date_count_down/date_count_down.dart';

class HomePage extends StatefulWidget {
  // const HomePage({ Key? key }) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  String uid;
  Timer _timer;
  @override
  void initState() {
    uid = _auth.currentUser.uid;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Widget build(BuildContext context) {
    CollectionReference _reference = FirebaseFirestore.instance.collection(uid);
    return Scaffold(
      appBar:
          AppBar(backgroundColor: Colors.blue, title: Text("Event Manager")),
      body: StreamBuilder(
        stream: _reference.snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView(
                children: snapshot.data.docs.map((DocumentSnapshot document) {
              final String eventName = document.data()["eventName"];
              final String date = document.data()["date"];
              final String location = document.data()["location"];

              final String dateCountDown =
                  CountDown().timeLeft(DateTime.parse(date), "Event Done");

              return GestureDetector(
                onTap: () {},
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                      border: Border.all(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    title: Text(
                      dateCountDown,
                      style: TextStyle(fontSize: 25, wordSpacing: 10),
                    ),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          eventName,
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          "Location",
                        )
                      ],
                    ),
                    trailing:
                        IconButton(icon: Icon(Icons.delete), onPressed: () {}),
                  ),
                ),
              );
            }).toList());
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => AddEventPage()));
        },
        label: Row(children: [Icon(Icons.add), Text("Add Event")]),
      ),
    );
  }
}
