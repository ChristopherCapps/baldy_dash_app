import '../model/crew.dart';
import '../model/player.dart';
import '../model/race.dart';
import '../model/session.dart';
import '../model/waypoint.dart';

abstract class RaceService {
  Stream<List<Race>> getRaces();

  Future<Race> getRaceById(String raceId);

  Stream<List<Session>> getSessions(Race race);

  Future<Session> getSessionById(String raceId, String sessionId);

  Stream<List<Crew>> getCrews(Race race, Session session);

  Stream<Crew> getCrew(Race race, Session session, Crew crew);

  Future<Player?> getPlayer();

  Future<Player?> getOtherPlayer(String id);

  Stream<List<Waypoint>> getWaypoints(Race race);

  Future<Player> createPlayer(Role role, String name);

  void update(Player player);

  Future<List<Player>> getPlayers(Crew crew);
}
