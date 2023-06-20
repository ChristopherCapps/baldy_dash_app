import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';

import '../model/course.dart';
import '../model/crew.dart';
import '../model/message.dart';
import '../model/player.dart';
import '../model/race.dart';
import '../model/racing_snapshot.dart';
import '../model/session.dart';
import '../model/waypoint.dart';
import 'firestore_service.dart';
import 'race_service.dart';

typedef JsonFactoryFunction<T> = T Function(Map<String, dynamic> json);
typedef JsonSerializationFunction<T> = Map<String, dynamic> Function(T entity);

const _messagesPathElement = 'messages';
const _playersPathElement = 'players';
const _racesPathElement = 'races';
const _sessionsPathElement = 'sessions';
const _coursesPathElement = 'courses';
const _crewsPathElement = 'crews';
const _waypointsPathElement = 'waypoints';

class FirestoreRaceService implements RaceService {
  static FirestoreRaceService? _instance;

  final String _uuid;
  final FirebaseFirestore _db;

  FirestoreRaceService._(this._db, this._uuid) {
    _instance = this;
  }

  static Future<FirestoreRaceService> init(
          final FirebaseFirestore db, final String uuid) async =>
      FirestoreRaceService._(db, uuid);

  static FirestoreRaceService get I => FirestoreRaceService._instance!;

  String _playersPath() => _playersPathElement;

  String _racesPath() => _racesPathElement;

  String _sessionsPath(final String raceId) =>
      '$_racesPathElement/$raceId/$_sessionsPathElement';

  String _crewsPath(final String raceId, final String sessionId) =>
      '$_racesPathElement/$raceId/$_sessionsPathElement/$sessionId/$_crewsPathElement';

  String _messagesPath(
          final String raceId, final String sessionId, final String crewId) =>
      '${_crewPath(raceId, sessionId, crewId)}/$_messagesPathElement';

  String _coursesPath(final String raceId) =>
      '$_racesPathElement/$raceId/$_coursesPathElement';

  String _waypointsPath(final String raceId, final String courseId) =>
      '${_coursePath(raceId, courseId)}/$_waypointsPathElement';

  String _playerPath(final String playerId) => '${_playersPath()}/$playerId';

  String _racePath(final String raceId) => '${_racesPath()}/$raceId';

  String _coursePath(final String raceId, final String courseId) =>
      '${_coursesPath(raceId)}/$courseId';

  String _sessionPath(final String raceId, final String sessionId) =>
      '${_sessionsPath(raceId)}/$sessionId';

  String _crewPath(
          final String raceId, final String sessionId, final String crewId) =>
      '${_crewsPath(raceId, sessionId)}/$crewId';

  String _messagePath(final String raceId, final String sessionId,
          final String crewId, final String messageId) =>
      '${_messagesPath(raceId, sessionId, crewId)}/$messageId';

  String _waypointPath(final String raceId, final String courseId,
          final String waypointId) =>
      '${_waypointsPath(raceId, courseId)}/$waypointId';

  @override
  Stream<List<Race>> getRaces() =>
      _getCollectionStream(_racesPath(), Race.fromJson);

  @override
  Future<Race> getRaceById(final String raceId) async => await _getDocument(
        _racePath(raceId),
        Race.fromJson,
      );

  @override
  Stream<Race> getRaceStreamById(final String raceId) async* {
    await for (final race in _getDocumentStream(
      _racePath(raceId),
      Race.fromJson,
    )) {
      yield race;
    }
  }

  // Future<Race> getRaceBySessionId(final String sessionId) async {

  // }

  @override
  Stream<Map<String, Waypoint>> getWaypointsStreamById(
          final String raceId, final String courseId) =>
      _getCollectionStream(_waypointsPath(raceId, courseId), Waypoint.fromJson)
          .map<Map<String, Waypoint>>((waypoints) =>
              {for (var waypoint in waypoints) waypoint.id: waypoint});

  @override
  Stream<Map<String, Waypoint>> getWaypoints(
          final Race race, final Course course) =>
      getWaypointsStreamById(race.id, course.id);

  @override
  Future<Session> getSessionById(String raceId, String sessionId) async =>
      await _getDocument(
        _sessionPath(raceId, sessionId),
        Session.fromJson,
      );

  @override
  Stream<Session> getSessionStreamById(String raceId, String sessionId) async* {
    await for (final session in _getDocumentStream(
      _sessionPath(raceId, sessionId),
      Session.fromJson,
    )) {
      yield session;
    }
  }

  @override
  Stream<List<Session>> getSessions(final Race race) =>
      _getCollectionStream(_sessionsPath(race.id), Session.fromJson);

  @override
  Future<List<Crew>> getCrews(final Race race, final Session session) =>
      _getCollection(_crewsPath(race.id, session.id), Crew.fromJson);

  @override
  Stream<List<Crew>> getCrewsStream(final Race race, final Session session) =>
      _getCollectionStream(_crewsPath(race.id, session.id), Crew.fromJson);

  @override
  Stream<Player> getPlayerStream() => _db
      .doc(_playerPath(_uuid))
      .snapshots()
      .map((snapshot) => _deserializeDocument(snapshot, Player.fromJson));

  @override
  Future<Player> getPlayer({final String? id}) async {
    final idOrDefault = id ?? _uuid;
    return idOrDefault == _uuid && !(await _playerExists())
        ? _createPlayer()
        : _getDocument(_playerPath(idOrDefault), Player.fromJson);
  }

  @override
  Stream<Crew> getCrewStream(
          final Race race, final Session session, final Crew crew) =>
      getCrewStreamById(race.id, session.id, crew.id);

  @override
  Stream<List<Message>> getMessagesStream(
          final Race race, final Session session, final Crew crew) =>
      getMessagesStreamById(race.id, session.id, crew.id);

  @override
  Future<Crew> getCrewById(String raceId, String sessionId, String crewId) =>
      _getDocument(_crewPath(raceId, sessionId, crewId), Crew.fromJson);

  @override
  Future<Crew> getCrewByPath(String crewPath) {
    final decomposedCrewPath = getDecomposedCrewPath(crewPath);
    return getCrewById(decomposedCrewPath.raceId, decomposedCrewPath.sessionId,
        decomposedCrewPath.crewId);
  }

  @override
  Stream<Crew> getCrewStreamById(
          String raceId, String sessionId, String crewId) =>
      _db
          .doc(_crewPath(raceId, sessionId, crewId))
          .snapshots()
          .map((snapshot) => _deserializeDocument(snapshot, Crew.fromJson));

  @override
  Stream<List<Message>> getMessagesStreamById(
    final String raceId,
    final String sessionId,
    final String crewId, {
    int? limit,
  }) =>
      _getCollectionStream(
        _messagesPath(raceId, sessionId, crewId),
        Message.fromJson,
        queryFn: <T>(query) => query
            .orderBy('timestamp', descending: false)
            .limitToLast(limit ?? 20),
      );

  bool _stringNotNullOrEmpty(final String? str) =>
      str != null && str.isNotEmpty;

  void _removePlayerFromCrew(final Player player, final Crew currentCrew,
      {final Transaction? transaction}) async {
    // Remove player from current crew and then save
    final updatedPlayers = Set<String>.from(currentCrew.players);
    updatedPlayers.remove(player.id);
    final updatedCrew = currentCrew.copyWith(players: updatedPlayers);
    updateCrew(updatedCrew, transaction: transaction);
  }

  @override
  void assignPlayerToCrew(final Player player, final Crew newCrew) async {
    final currentCrew = _stringNotNullOrEmpty(player.crewPath)
        ? await getCrewByPath(player.crewPath!)
        : null;

    await FirestoreService.I.runTransaction(
      (transaction) async {
        if (currentCrew != null) {
          _removePlayerFromCrew(player, currentCrew, transaction: transaction);
        }
        // Add player to new crew and then save
        final updatedPlayers = Set<String>.from(newCrew.players);
        updatedPlayers.add(player.id);
        final updatedCrew = newCrew.copyWith(players: updatedPlayers);
        updateCrew(updatedCrew, transaction: transaction);
        // Update the player's crew path and then save
        final updatedPlayer = player.copyWith(crewPath: newCrew.path);
        updatePlayer(updatedPlayer, transaction: transaction);
      },
    );
  }

  @override
  void removePlayerFromCrew(final Player player) async {
    final currentCrew = _stringNotNullOrEmpty(player.crewPath)
        ? await getCrewByPath(player.crewPath!)
        : null;

    await FirestoreService.I.runTransaction(
      (transaction) async {
        if (currentCrew != null) {
          _removePlayerFromCrew(player, currentCrew, transaction: transaction);
        }
        updatePlayer(player.copyWith(crewPath: ''), transaction: transaction);
      },
    );
  }

  @override
  Stream<Set<String>> getPlayersForCrew(
          final Race race, final Session session, final Crew crew) =>
      getCrewStream(race, session, crew).map((snapshot) => snapshot.players);

  Future<Player> _createPlayer({final Role? role, final String? name}) async {
    final nameOrDefault = (name ?? Player.newPlayerName).trim();
    final normalizedRole = nameOrDefault.toUpperCase() == 'GM'
        ? Role.gamemaster
        : role ?? Role.participant;
    final normalizedName =
        role == Role.gamemaster ? 'Master Chris' : nameOrDefault;

    return await _createWithId(
      _uuid,
      _playersPath(),
      Player(
        _uuid,
        _playerPath(_uuid),
        role: normalizedRole,
        name: normalizedName,
      ),
      Player.toJson,
    );
  }

  Future<List<Crew>> _getCrews(final Race race, final Session session) =>
      _getCollection(_crewsPath(race.id, session.id), Crew.fromJson);

  String _messagesPathForSnapshot(final RacingSnapshot racingSnapshot) =>
      _messagesPath(
        racingSnapshot.race.id,
        racingSnapshot.session.id,
        racingSnapshot.crew.id,
      );

  @override
  Stream<List<Message>> getMessagesForCrew(
          final Race race, final Session session, final Crew crew) =>
      _getCollectionStream(
          _messagesPath(race.id, session.id, crew.id), Message.fromJson);

  @override
  Future<void> sendTaunt(
    final Player fromPlayer,
    final RacingSnapshot fromRacingSnapshot,
    final String text,
  ) async =>
      _getCrews(fromRacingSnapshot.race, fromRacingSnapshot.session).then(
          (allCrewsInThisSession) => allCrewsInThisSession
              .where((crew) => crew.id != fromRacingSnapshot.crew.id)
              .forEach(
                (crew) => _create<Message>(
                  _messagesPathForSnapshot(fromRacingSnapshot),
                  Message.now(fromPlayer.name, text),
                  Message.toJson,
                ),
              ));

  @override
  Future<Message> sendMessageFromGameMasterToPlayer(
    final Player toPlayer,
    final RacingSnapshot toRacingSnapshot,
    final String text, {
    final String? photoUrl,
  }) async =>
      _sendMessageToPlayer(
        'GAME MASTER',
        toPlayer,
        toRacingSnapshot,
        text,
        photoUrl: photoUrl,
      );

  @override
  Future<Message> sendMessageFromRaceToPlayer(
    final Player toPlayer,
    final RacingSnapshot toRacingSnapshot,
    final String text, {
    final String? photoUrl,
  }) async =>
      _sendMessageToPlayer(
        'BALDY DASH',
        toPlayer,
        toRacingSnapshot,
        text,
        photoUrl: photoUrl,
      );

  Future<Message> _sendMessageToPlayer(
    final String senderName,
    final Player toPlayer,
    final RacingSnapshot toRacingSnapshot,
    final String text, {
    final String? photoUrl,
  }) async =>
      _create<Message>(
        _messagesPathForSnapshot(toRacingSnapshot),
        Message.now(
          senderName,
          text,
          toPlayerId: toPlayer.id,
          photoUrl: photoUrl,
        ),
        Message.toJson,
      );

  @override
  Future<Message> sendMessageFromRaceToCrew(
          RacingSnapshot toRacingSnapshot, String text,
          {String? photoUrl}) async =>
      _sendMessageToCrew(
        'BALDY DASH (WAYPOINT ${toRacingSnapshot.crew.waypointId})',
        toRacingSnapshot,
        text,
        photoUrl,
      );

  @override
  Future<Message> sendMessageFromGameMasterToCrew(
          RacingSnapshot toRacingSnapshot, String text,
          {String? photoUrl}) async =>
      _sendMessageToCrew(
        'GAME MASTER',
        toRacingSnapshot,
        text,
        photoUrl,
      );

  Future<Message> _sendMessageToCrew(
          final String senderName,
          final RacingSnapshot toRacingSnapshot,
          final String text,
          final String? photoUrl) async =>
      _create<Message>(
          _messagesPathForSnapshot(toRacingSnapshot),
          Message.now(
            senderName,
            text,
            photoUrl: photoUrl,
          ),
          Message.toJson);

  @override
  void updatePlayer(final Player player, {Transaction? transaction}) async {
    _update(_playerPath(player.id), player, Player.toJson,
        transaction: transaction);
  }

  @override
  void updateCrew(Crew crew, {Transaction? transaction}) async {
    _update(crew.path, crew, Crew.toJson, transaction: transaction);
  }

  @override
  DecomposedCrewPath getDecomposedCrewPath(String crewPath) {
    final pattern = RegExp(r'races\/(\w+)\/sessions\/(\w+)\/crews\/(\w+)');

    if (!pattern.hasMatch(crewPath)) {
      throw Exception('Invalid input format: "$crewPath"');
    }

    final match = pattern.firstMatch(crewPath)!;

    return (
      raceId: match.group(1)!,
      sessionId: match.group(2)!,
      crewId: match.group(3)!,
    );
  }

  Future<bool> _playerExists() async =>
      _db.doc(_playerPath(_uuid)).get().then((snapshot) => snapshot.exists);

  Future<T> _createWithId<T>(
    final String id,
    final String collectionPath,
    T entity,
    JsonSerializationFunction<T> serializationFn,
  ) async {
    print('Creating new document within collection $collectionPath: $entity');
    final documentPath = '$collectionPath/$id';
    await _db.doc(documentPath).set(serializationFn(entity));
    return entity;
  }

  Future<T> _create<T>(
    final String collectionPath,
    T entity,
    JsonSerializationFunction<T> serializationFn,
  ) async =>
      _createWithId(
        const Uuid().v1(),
        collectionPath,
        entity,
        serializationFn,
      );

  void _update<T>(
    final String entityPath,
    T entity,
    JsonSerializationFunction<T> serializationFn, {
    Transaction? transaction,
  }) async {
    final documentReference = _db.doc(entityPath);

    Transaction updateWithinTransaction(Transaction t) => t.update(
          documentReference,
          serializationFn(entity),
        );

    if (transaction != null) {
      updateWithinTransaction(transaction);
    } else {
      await _db.runTransaction(
        (transaction) async {
          updateWithinTransaction(transaction);
        },
      ).catchError(
        // ignore: avoid_print, invalid_return_type_for_catch_error
        (error) => print('Failed to update entity: $error'),
      );
    }
  }

  Stream<T> _getDocumentStream<T>(
      final String path, JsonFactoryFunction<T> jsonFactoryFn) async* {
    print('Fetching document stream at $path');
    final snapshots = _db.doc(path).snapshots();
    await for (final snapshot in snapshots) {
      yield _deserializeDocument<T>(snapshot, jsonFactoryFn);
    }
  }

  Future<T> _getDocument<T>(
    final String path,
    final JsonFactoryFunction<T> jsonFactoryFn, {
    final T? newDocument,
  }) async {
    print('Fetching document at $path');
    return _db.doc(path).get().then((snapshot) => snapshot.exists
        ? _deserializeDocument<T>(snapshot, jsonFactoryFn)
        : throw Exception(
            'Requested load of non-existent document at path $path'));
  }

  T _deserializeDocument<T>(
      final DocumentSnapshot<Map<String, dynamic>> snapshot,
      final JsonFactoryFunction<T> jsonFactoryFn) {
    final data = snapshot.data()!;
    data['id'] = snapshot.id;
    data['path'] = snapshot.reference.path;
    for (final key in data.keys) {
      final value = data[key];
      if (value is Timestamp) {
        data[key] = value.toDate().toIso8601String();
      }
    }
    return jsonFactoryFn(data);
  }

  Future<List<T>> _getCollection<T>(
          final String path, final JsonFactoryFunction<T> jsonFactoryFn,
          {int? limit}) async =>
      _db.collection(path).limit(limit ?? 100).get().then(
            (querySnapshots) => querySnapshots.docs.fold<List<T>>(
              [],
              (documents, doc) => [
                ...documents,
                _deserializeDocument(doc, jsonFactoryFn),
              ],
            ),
          );

  Stream<List<T>> _getCollectionStream<T>(
    final String path,
    final JsonFactoryFunction<T> jsonFactoryFn, {
    Query<T> Function<T>(Query<T>)? queryFn,
    int? limit,
  }) {
    final baseQuery = _db.collection(path).limit(limit ?? 100);
    final finalQuery = queryFn != null ? queryFn(baseQuery) : baseQuery;
    return finalQuery.snapshots().map(
          (snapshot) => snapshot.docs.fold<List<T>>(
            [],
            (documents, doc) => [
              ...documents,
              _deserializeDocument(doc, jsonFactoryFn),
            ],
          ),
        );
  }

  @override
  Stream<RacingSnapshot> getRacingStreamByRaceAndSessionAndCrew(
          final String raceId, final String sessionId, final String crewId) =>
      CombineLatestStream.combine3(
          getRaceStreamById(raceId),
          getSessionStreamById(raceId, sessionId),
          getCrewStreamById(raceId, sessionId, crewId),
          (race, session, crew) => (race: race, session: session, crew: crew));

  @override
  Stream<RacingSnapshotWithWaypoints>
      getRacingStreamWithWaypointsByRaceAndSessionAndCrewAndCourse(
    final String raceId,
    final String sessionId,
    final String crewId,
    final String courseId,
  ) =>
          CombineLatestStream.combine4(
            getRaceStreamById(raceId),
            getSessionStreamById(raceId, sessionId),
            getCrewStreamById(raceId, sessionId, crewId),
            getWaypointsStreamById(raceId, courseId),
            (race, session, crew, waypoints) => (
              race: race,
              session: session,
              crew: crew,
              waypoints: waypoints
            ),
          );

  @override
  Future<Set<Player>> getPlayers(final Crew crew) async {
    var players = <Player>{};
    for (final playerId in crew.players) {
      final player = await getPlayer(id: playerId);
      players = {...players, player};
    }
    return players;
  }

  String _getUniqueId() => const Uuid().v1();
}
