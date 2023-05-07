import '../model/course.dart';
import '../model/crew.dart';
import '../model/gaming_snapshot.dart';
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

  Stream<Crew> getCrewStream(Race race, Session session, Crew crew);

  Stream<Crew> getCrewStreamById(
      String raceId, String sessionId, String crewId);

  Future<Player> getPlayer();

  Future<Player> getOtherPlayer(String id);

  Stream<Map<String, Waypoint>> getWaypointsStreamById(
      final String raceId, final String courseId);

  Stream<Map<String, Waypoint>> getWaypoints(Race race, Course course);

  Future<Player> createPlayer(Role role, String name);

  Stream<GamingSnapshot> getGamingStreamById(
      String raceId, String sessionId, String crewId, String courseId);

  void update(Player player);

  Future<List<Player>> getPlayers(Crew crew);
}
