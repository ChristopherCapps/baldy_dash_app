import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/crew.dart';
import '../model/player.dart';
import '../model/race.dart';
import '../model/session.dart';
import '../model/waypoint.dart';
import 'race_service.dart';

typedef JsonFactoryFunction<T> = T Function(Map<String, dynamic> json);
typedef JsonSerializationFunction<T> = Map<String, dynamic> Function(T entity);

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
  Stream<List<Race>> getRaces() => _getCollection('races', Race.fromJson);

  @override
  Stream<List<Waypoint>> getWaypoints(final Race race) =>
      _getCollection('races/${race.id}/waypoints', Waypoint.fromJson);

  @override
  Stream<List<Session>> getSessions(final Race race) =>
      _getCollection('races/${race.id}/sessions', Session.fromJson);

  @override
  Stream<List<Crew>> getCrews(final Race race, final Session session) =>
      _getCollection(
          'races/${race.id}/sessions/${session.id}/crews', Crew.fromJson);

  @override
  Future<Player?> getPlayer(final String id) =>
      _getDocument('players/$id', Player.fromJson);

  @override
  Stream<Crew> getCrew(
          final Race race, final Session session, final Crew crew) =>
      _db
          .doc('race/${race.id}/sessions/${session.id}/crews/${crew.id}')
          .snapshots()
          .map((snapshot) => Crew.fromJson(snapshot.data()!));

  Stream<List<String>> getPlayersForCrew(
          final Race race, final Session session, final Crew crew) =>
      getCrew(race, session, crew).map((snapshot) => snapshot.players);

  @override
  Future<Player> create(final Player player) async =>
      await _create('players/${player.id}', player, Player.toJson);

  @override
  void update(final Player player) async {
    _update('players/${player.id}', player, Player.toJson);
  }

  Future<T> _create<T>(final String path, T entity,
      JsonSerializationFunction<T> serializationFn) async {
    await _db.doc(path).set(serializationFn(entity));
    return entity;
  }

  void _update<T>(final String path, T entity,
      JsonSerializationFunction<T> serializationFn) async {
    final documentReference = _db.doc(path);
    await _db.runTransaction(
      (transaction) async {
        final snapshot = await transaction.get(documentReference);
        if (!snapshot.exists) {
          throw Exception('Entity at path $path does not exist');
        }
        transaction.update(documentReference, serializationFn(entity));
      },
    ).catchError(
      // ignore: avoid_print, invalid_return_type_for_catch_error
      (error) => print('Failed to update entity: $error'),
    );
  }

  Future<T?> _getDocument<T>(
          final String path, JsonFactoryFunction<T> jsonFactoryFn) async =>
      _db.doc(path).get().then((snapshot) =>
          snapshot.exists ? jsonFactoryFn(snapshot.data()!) : null);

  Stream<List<T>> _getCollection<T>(
          final String path, JsonFactoryFunction<T> jsonFactoryFn) =>
      _db
          .collection(path)
          .snapshots()
          .map((snapshot) => snapshot.docs.fold<List<T>>(
                [],
                (documents, doc) {
                  final data = doc.data();
                  data['id'] = doc.id;
                  for (final key in data.keys) {
                    final value = data[key];
                    if (value is Timestamp) {
                      data[key] = value.toDate().toIso8601String();
                    }
                  }
                  return [...documents, jsonFactoryFn(data)];
                },
              ));
}
