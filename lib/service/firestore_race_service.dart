import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/session.dart';
import '../model/race.dart';
import '../model/player.dart';
import '../model/message.dart';
import '../model/crew.dart';
import 'race_service.dart';

// TODO: Need to refactor and delegate to a repo

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
  Stream<List<Crew>> getCrews(final Race race, final Session session) {
    getSession(race, session).then((session) => _db
        .collection('races/${race.id}/sessions/${session.id}/crews')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.fold<List<Crew>>(
            [],
            (listOfCrews, doc) {
              final data = doc.data();
              data['id'] = doc.id;
              return [...listOfCrews, Crew.fromJson(data)];
            },
          ),
        ));
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

  Future<Session> getSession(final Race race, final Session session) => _db
      .doc('races/${race.id}/sessions/${session.id}')
      .get()
      .then((snapshot) => Session.fromJson(snapshot.data()!));

  @override
  Stream<List<Session>> getSessions(final Race race) => _db
      .collection('races')
      .doc(race.id)
      .collection('sessions')
      .snapshots()
      .map(
        (snapshot) => snapshot.docs.fold<List<Session>>(
          [],
          (listOfSessions, doc) {
            final data = doc.data();
            data['id'] = doc.id;
            return [...listOfSessions, Session.fromJson(data)];
          },
        ),
      );
}
