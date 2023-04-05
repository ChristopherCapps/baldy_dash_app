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

  types.Message getMessage(
      final QueryDocumentSnapshot<Map<String, Object?>> messageDoc) {
    return types.Message(
      authorUuid: messageDoc.get("authorUuid"),
      text: messageDoc.get("text"),
      imageUrl: messageDoc.get("imageUrl"),
    );
  }

  types.Player getPlayer(
      final QueryDocumentSnapshot<Map<String, Object?>> playerDoc) {
    return types.Player(
      name: playerDoc.get("name"),
      uuid: playerDoc.get("uuid"),
    );
  }

  Future<types.Crew> getCrew(
      final QueryDocumentSnapshot<Map<String, Object?>> crewDoc) async {
    final players = await crewDoc.reference
        .collection("players")
        .get()
        .then((playersRef) =>
            playersRef.docs.map((playerDoc) => getPlayer(playerDoc)));

    final messages = await crewDoc.reference
        .collection("transcript")
        .get()
        .then((transcriptRef) =>
            transcriptRef.docs.map((messageDoc) => getMessage(messageDoc)));

    return types.Crew(
      name: crewDoc.get("name"),
      players: players.toList(),
      transcript: messages.toList(),
    );
  }

  Future<types.Session> getSession(
      final QueryDocumentSnapshot<Map<String, Object?>> sessionDoc) async {
    final crewsRef = await sessionDoc.reference
        .collection("crews")
        .get();

    List<types.Crew> crews = [];
    for (var crewRef in crewsRef.docs) {
      crews = crews + [await getCrew(crewRef)];
    }

    return types.Session(
      name: sessionDoc.get("name"),
      startTime: sessionDoc.get("startTime"),
      crews: crews.toList(),
    );
  }

  Future<types.Race> getRace(final String id) async {
    final DocumentSnapshot doc = await _db.collection("races").doc(id).get();
    if (!doc.exists) {
      throw Exception("The race with document id $id does not exist.");
    }

    final sessionsRef = await doc.reference.collection("sessions").get();

    List<types.Session> sessions = [];
    for (var sessionRef in sessionsRef.docs) {
      sessions = sessions + [await getSession(sessionRef)];
    }

    return types.Race(
      name: doc.get("name"),
      logoUrl: doc.get("logoUrl"),
      sessions: sessions,
    );
  }
}
