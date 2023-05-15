import 'model/crew.dart';
import 'model/player.dart';
import 'model/session.dart';
import 'service/race_service.dart';

class Engine {
  static Engine? _instance;

  static Engine initialize(final RaceService raceService) {
    if (_instance != null) {
      return _instance!;
    }

    _instance = Engine._(raceService);

    return _instance!;
  }

  final RaceService _raceService;
  Player? _player;

  Engine._(this._raceService) {
    _raceService.getPlayerStream().listen(
          _onPlayerUpdated,
          onError: _onPlayerUpdateError,
        );
  }

  void _onPlayerUpdated(final Player player) {
    print('Engine updated player: $player');
    _player = player;
  }

  void _onPlayerUpdateError(final Object error, final StackTrace stackTrace) {
    print('Failed during player update: $error\n$stackTrace');
  }

  Player get player => _player!;

  bool playerNameIsUnset() => player.name == Player.newPlayerName;

  Future<Crew?> getWinningCrew(final Session session) async =>
      session.winningCrewPath != null && session.winningCrewPath!.isNotEmpty
          ? _raceService.getCrewByPath(session.winningCrewPath!)
          : null;

  static Engine get I => _instance!;
}
