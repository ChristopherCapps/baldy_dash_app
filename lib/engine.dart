import 'model/command.dart';
import 'model/crew.dart';
import 'model/player.dart';
import 'model/race.dart';
import 'model/racing_snapshot.dart';
import 'model/session.dart';
import 'service/message_service.dart';
import 'service/race_service.dart';

class Engine {
  static Engine? _instance;

  static Future<Engine> initialize(
    final RaceService raceService,
    final MessageService messageService,
  ) async {
    if (_instance != null) {
      return _instance!;
    }

    final engine = Engine._(raceService);
    _instance = engine;

    // Make sure there's an initial value here before completing initialization
    engine._onPlayerUpdated(await raceService.getPlayer());

    return _instance!;
  }

  final RaceService _raceService;
  final MessageService _messageService;
  Player? _player;

  Engine._(this._raceService, this._messageService) {
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

  void assignPlayerToCrew(final Crew crew) async {
    _raceService.assignPlayerToCrew(player, crew);
  }

  Future<Set<Crew>> getOpposingCrews(
          final Race race, final Session session, final Crew crew) async =>
      Set.from(
        (await _raceService.getCrews(race, session))
            .where((otherCrew) => crew.id != otherCrew.id),
      );

  void handleCommand(
    final RacingSnapshotWithWaypoints racingSnapshotWithWaypoints,
    final Command command,
    final String args,
  ) =>
      command.onCommand(
          this, _messageService, racingSnapshotWithWaypoints, args);

  static Engine get I => _instance!;
}
