import '../model/course.dart';
import '../model/crew.dart';

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

  Stream<List<Crew>> getCrews(Race race, Session session);

  Future<Crew> getCrewById(String raceId, String sessionId, String crewId);

  Future<Crew> getCrewByPath(String crewPath);

  Stream<Crew> getCrewStream(Race race, Session session, Crew crew);

  Stream<Crew> getCrewStreamById(
      String raceId, String sessionId, String crewId);

  void assignPlayerToCrew(Crew crew);

  Future<Player> getPlayer();

  Stream<Player> getPlayerStream();

  Future<Player> getOtherPlayer(String id);

  Stream<Map<String, Waypoint>> getWaypointsStreamById(
      final String raceId, final String courseId);

  Stream<Map<String, Waypoint>> getWaypoints(Race race, Course course);

  Future<Player> createPlayer(Role role, String name);

  void updatePlayer(Player player);

  void updateCrew(Crew crew);

  Future<Set<Player>> getPlayers(Crew crew);

  Stream<Set<String>> getPlayersForCrew(
      final Race race, final Session session, final Crew crew);

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
