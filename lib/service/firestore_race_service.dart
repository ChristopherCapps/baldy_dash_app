import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/session.dart';
import '../model/race.dart';
import '../model/player.dart';
import '../model/message.dart';
import '../model/crew.dart';
import 'race_service.dart';

class FirestoreRaceService implements RaceService {
  static FirestoreRaceService? _instance;

  final FirebaseFirestore _db;

  FirestoreRaceService._(this._db) {
    _instance = this;
  }

  static Future<FirestoreRaceService> init(final FirebaseFirestore db) async =>
      FirestoreRaceService._(db);

  static FirestoreRaceService get I => FirestoreRaceService._instance!;

  @override
  List<Crew> getCrews(Session session) {
    // TODO: implement getCrews
    throw UnimplementedError();
  }

  @override
  List<Message> getMessages({required Crew crew, int? maxMessages}) {
    // TODO: implement getMessages
    throw UnimplementedError();
  }

  @override
  List<Player> getPlayers(Crew crew) {
    // TODO: implement getPlayers
    throw UnimplementedError();
  }

  @override
  Stream<List<Race>> getRaces() => _db.collection('races').snapshots().map(
        (snapshot) => snapshot.docs.fold<List<Race>>(
          [],
          (listOfRaces, doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return [...listOfRaces, Race.fromJson(data)];
          },
        ),
      );

  @override
  List<Session> getSessions(Race race) {
    // TODO: implement getSessions
    throw UnimplementedError();
  }
}