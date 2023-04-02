import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/race.dart';

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

    var name = snapshot.get("name");

    var snapshots = _db
        .collection("races")
        .doc("vtGu6oxrs1uTYvb919VZ")
        .collection("sessions")
        .snapshots();
    var data = snapshot.data()!;

    return snapshot.get("name");
  }
}
