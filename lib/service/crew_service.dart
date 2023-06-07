import '../model/crew.dart';

import 'race_service.dart';

abstract class CrewService {
  static CrewService of(final RaceService raceService) =>
      _DefaultCrewService(raceService);

  Future<Crew> getCrewByPath(String crewPath);
  //Future<void> updatePlayer(Player player);
}

class _DefaultCrewService extends CrewService {
  final RaceService _raceService;

  _DefaultCrewService(this._raceService);

  @override
  Future<Crew> getCrewByPath(final String crewPath) async =>
      _raceService.getCrewByPath(crewPath);
}
