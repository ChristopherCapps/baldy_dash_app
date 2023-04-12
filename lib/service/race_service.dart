import '../model/crew.dart';
import '../model/message.dart';
import '../model/player.dart';
import '../model/race.dart';
import '../model/session.dart';
import '../model/waypoint.dart';

abstract class RaceService {
  Stream<List<Race>> getRaces();

  Stream<List<Session>> getSessions(Race race);

  List<Crew> getCrews(Session session);

  List<Player> getPlayers(Crew crew);

  List<Message> getMessages({required Crew crew, int? maxMessages});

  Stream<Waypoint> getWaypoints(Race race, Session session);

  String sendMessage(String text);
}
