import '../model/course.dart';
import '../model/crew.dart';
import '../model/message.dart';
import '../model/player.dart';
import '../model/race.dart';
import '../model/racing_snapshot.dart';
import '../model/session.dart';
import '../model/waypoint.dart';

abstract class RaceService {
  Stream<List<Race>> getRaces();

  Future<Race> getRaceById(String raceId);

  Stream<Race> getRaceStreamById(String raceId);

  Stream<List<Session>> getSessions(Race race);

  Future<Session> getSessionById(String raceId, String sessionId);

  Stream<Session> getSessionStreamById(String raceId, String sessionId);

  Future<List<Crew>> getCrews(Race race, Session session);

  Stream<List<Crew>> getCrewsStream(Race race, Session session);

  Future<Crew> getCrewById(String raceId, String sessionId, String crewId);

  Future<Crew> getCrewByPath(String crewPath);

  Stream<Crew> getCrewStream(Race race, Session session, Crew crew);

  Stream<Crew> getCrewStreamById(
      String raceId, String sessionId, String crewId);

  void assignPlayerToCrew(Player player, Crew crew);

  void removePlayerFromCrew(Player player);

  Future<Player> getPlayer({String? id});

  Stream<Player> getPlayerStream();

  Stream<Map<String, Waypoint>> getWaypointsStreamById(
      String raceId, String courseId);

  Stream<Map<String, Waypoint>> getWaypoints(Race race, Course course);

  Future<void> sendTaunt(
    Player fromPlayer,
    RacingSnapshot fromRacingSnapshot,
    String text,
  );

  Future<Message> sendMessageFromGameMasterToPlayer(
    Player toPlayer,
    RacingSnapshot toRacingSnapshot,
    String text, {
    String? photoUrl,
  });

  Future<Message> sendMessageFromRaceToPlayer(
    Player toPlayer,
    RacingSnapshot toRacingSnapshot,
    String text, {
    String? photoUrl,
  });

  Future<Message> sendMessageFromRaceToCrew(
      RacingSnapshot toRacingSnapshot, String text,
      {String? photoUrl});

  Future<Message> sendMessageFromGameMasterToCrew(
      RacingSnapshot toRacingSnapshot, String text,
      {String? photoUrl});

  Stream<List<Message>> getMessagesForCrew(
      Race race, Session session, Crew crew);

  void updatePlayer(Player player);

  void updateCrew(Crew crew);

  Future<Set<Player>> getPlayers(Crew crew);

  Stream<Set<String>> getPlayersForCrew(Race race, Session session, Crew crew);

  Stream<List<Message>> getMessagesStream(
      Race race, Session session, Crew crew);

  Stream<List<Message>> getMessagesStreamById(
    String raceId,
    String sessionId,
    String crewId, {
    int? limit,
  });

  DecomposedCrewPath getDecomposedCrewPath(String crewPath);

  Stream<RacingSnapshot> getRacingStreamByRaceAndSessionAndCrew(
    String raceId,
    String sessionId,
    String crewId,
  );

  Stream<RacingSnapshotWithWaypoints>
      getRacingStreamWithWaypointsByRaceAndSessionAndCrewAndCourse(
    String raceId,
    String sessionId,
    String crewId,
    String courseId,
  );
}
