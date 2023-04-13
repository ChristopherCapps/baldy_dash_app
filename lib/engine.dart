import 'model/player.dart';
import 'service/race_service.dart';
import 'service/settings.dart';

class Engine {
  static Engine? _instance;

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

    _instance = Engine._(player);

    return _instance!;
  }

  Player player;

  Engine._(this.player);

  static Engine get I => _instance!;
}
