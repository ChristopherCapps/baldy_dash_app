import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/types.dart' as types;

class FirestoreService {
  static FirestoreService? _instance;

  final FirebaseFirestore _db;

  FirestoreService._() : _db = FirebaseFirestore.instance {
    _instance = this;
  }

  static Future<FirestoreService> init(FirebaseOptions firebaseOptions) async {
    if (FirestoreService._instance != null) {
      throw Exception("Already initialized");
    }
    await Firebase.initializeApp(
      options: firebaseOptions,
    );

    return FirestoreService._();
  }

  static FirestoreService get I => FirestoreService._instance!;

  // Future<Race> get races => {
  //   await _db.collection("races")
  //   .withConverter(fromFirestore: (snapshot, _) => Race.to, toFirestore: toFirestore)
  // }

  Future<String> getRaceName() async {
    final DocumentSnapshot snapshot =
        await _db.collection("races").doc("vtGu6oxrs1uTYvb919VZ").get();

    if (!snapshot.exists) {
      return "Error! Race is missing.";
    }
    return snapshot.get("name");
  }

  Future<types.Race> getRace(String id) async {
    final DocumentSnapshot doc = await _db.collection("races").doc(id).get();
    if (!doc.exists) {
      throw Exception("The race with document id $id does not exist.");
    }

    final data = doc.data()! as Map<String, Object?>;

    var sessions = await doc.reference.collection("sessions").get();
    sessions.docs.forEach((element) {print("Session doc: ${element.data()}");});
    // sessions.snapshots().forEach((element) {
    //   element.docs.forEach((element) {
    //     print("id ${element.id} with data ${element.data()!}");});});
    print("Sessions: $sessions");

    return types.Race.fromJson(data);
  }
}
