import '../model/crew.dart';
import '../model/player.dart';
import '../model/race.dart';
import '../model/session.dart';
import '../model/waypoint.dart';

abstract class RaceService {
  Stream<List<Race>> getRaces();

  Stream<List<Session>> getSessions(Race race);

  Stream<List<Crew>> getCrews(Race race, Session session);

  Future<Player?> getPlayer(String id);

  Stream<List<Waypoint>> getWaypoints(Race race);

  Future<Player> create(Player player);

  void update(Player player);
}
