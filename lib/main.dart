import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';

import 'app.dart';
import 'model/app_state_model.dart';                 // NEW

void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  var db = FirebaseFirestore.instance;
  final user = <String, dynamic> {
    "first": "Ada",
    "last": "LoveLace"
  };
  var races = db.collection("races");
  var id = races.id;
  races.add(user).then((DocumentReference doc) => print('Snapshot added: ${doc.path}'));

  return runApp(
    ChangeNotifierProvider<AppStateModel>(            // NEW
      create: (_) => AppStateModel(), // NEW
      child: const BaldyDashApp(),               // NEW
    ),
  );
}