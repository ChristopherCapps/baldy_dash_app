import 'model/player.dart';
import 'service/race_service.dart';
import 'service/settings.dart';

class Engine {
  static Future<Engine> initialize(
      final Settings settings, final RaceService raceService) async {
    final playerId = settings.uuid;

    final player = await (raceService.getPlayer(playerId)) ??
        await raceService.create(
          Player(
            id: playerId,
            role: Role.participant,
          ),
        );

    return Engine._(player);
  }

  Player player;

  Engine._(this.player);
}
