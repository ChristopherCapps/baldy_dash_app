import '../model/player.dart';

import 'race_service.dart';

abstract class PlayerService {
  static PlayerService of(final RaceService raceService) =>
      _DefaultPlayerService(raceService);

  Future<Player> getPlayer({String? id});
  Future<void> updatePlayer(Player player);
}

class _DefaultPlayerService extends PlayerService {
  final RaceService _raceService;

  _DefaultPlayerService(this._raceService);

  @override
  Future<Player> getPlayer({final String? id}) async =>
      _raceService.getPlayer(id: id);

  @override
  Future<void> updatePlayer(final Player player) async =>
      _raceService.updatePlayer(player);
}
