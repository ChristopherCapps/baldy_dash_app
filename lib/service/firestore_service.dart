import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class FirestoreService {
  static FirestoreService? _instance;

  final FirebaseFirestore _db;

  FirestoreService._() : _db = FirebaseFirestore.instance {
    _instance = this;
  }

  static Future<FirestoreService> init(FirebaseOptions firebaseOptions) async {
    if (FirestoreService._instance != null) {
      throw Exception('Already initialized');
    }
    await Firebase.initializeApp(
      options: firebaseOptions,
    );

    return FirestoreService._();
  }

  FirebaseFirestore get database => _db;

  static FirestoreService get I => FirestoreService._instance!;
}
