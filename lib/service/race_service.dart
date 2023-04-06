import '../model/crew.dart';
import '../model/message.dart';
import '../model/player.dart';
import '../model/race.dart';
import '../model/session.dart';

abstract class RaceService {
  Stream<List<Race>> getRaces();

  List<Session> getSessions(Race race);

  List<Crew> getCrews(Session session);

  List<Player> getPlayers(Crew crew);

  List<Message> getMessages({required Crew crew, int? maxMessages});
}
