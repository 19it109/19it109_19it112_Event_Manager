import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseClass {
  String uid;
  DatabaseClass(this.uid);

  //add
  Future addEvents(
      {required String eventName,
      required String location,
      required String description,
      required String date}) async {
    CollectionReference _events = FirebaseFirestore.instance.collection(uid);
    try {
      final body = {
        "eventName": eventName,
        "location": location,
        "Description": description,
        "Date": date,
      };
      await _events.add(body);

      return "Event added successfully";
    } catch (e) {
      return "unable to add Event $e";
    }
  }

//update
  Future updateEvents(
      {required String id,
      required String eventName,
      required String location,
      required String description,
      required String date}) async {
    CollectionReference _events = FirebaseFirestore.instance.collection(uid);
    try {
      final body = {
        "eventName": eventName,
        "location": location,
        "Description": description,
        "Date": date,
      };
      await _events.doc(id).update(body);

      return "Event updated successfully";
    } catch (e) {
      return "unable to update Event $e";
    }
  }

  //delete
  Future deleteEvent({
    required String id,
  }) async {
    CollectionReference _events = FirebaseFirestore.instance.collection(uid);
    try {
      await _events.doc(id).delete();

      return "Event deleted successfully";
    } catch (e) {
      return "unable to delete Event $e";
    }
  }
}
