import '../model/course.dart';
import '../model/crew.dart';
import '../model/message.dart';
import '../model/player.dart';
import '../model/race.dart';
import '../model/session.dart';
import '../model/waypoint.dart';

abstract class RaceService {
  Stream<List<Race>> getRaces();

  Future<Race> getRaceById(String raceId);

  Stream<Race> getRaceStreamById(String raceId);

  Stream<List<Session>> getSessions(Race race);

  Future<Session> getSessionById(String raceId, String sessionId);

  Stream<Session> getSessionStreamById(String raceId, String sessionId);

  Stream<List<Crew>> getSessionCrews(Race race, Session session);

  Future<List<Crew>> getSessionCrewsById(String raceId, String sessionId);

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
    final Player fromPlayer,
    final RacingSnapshot fromRacingSnapshot,
    final String text,
  );

  void updatePlayer(Player player);

  void updateCrew(Crew crew);

  Future<Set<Player>> getPlayers(Crew crew);

  Stream<Set<String>> getPlayersForCrew(Race race, Session session, Crew crew);

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

typedef DecomposedCrewPath = ({String raceId, String sessionId, String crewId});

typedef RacingSnapshot = ({Race race, Session session, Crew crew});

typedef RacingSnapshotWithWaypoints = ({
  Race race,
  Session session,
  Crew crew,
  Map<String, Waypoint> waypoints,
});
