import 'package:meta/meta.dart';

import '../../service/message_service.dart';
import '../engine.dart';
import 'crew.dart';
import 'player.dart';
import 'race.dart';
import 'racing_snapshot.dart';
import 'session.dart';
import 'waypoint.dart';

abstract class Command {
  late RacingSnapshotWithWaypoints _lastSnapshotWithWaypoints;

  void _onCommand(
    final Engine engine,
    final MessageService messageService,
    final Player player,
    final Race race,
    final Session session,
    final Crew crew,
    final Map<String, Waypoint> waypoints,
    final String args,
  );

  void onCommand(
    final Engine engine,
    final MessageService messageService,
    final RacingSnapshotWithWaypoints racingSnapshot,
    final String args,
  ) {
    final normalizedArgs = args.trim();
    _lastSnapshotWithWaypoints = racingSnapshot;
    _onCommand(
      engine,
      messageService,
      engine.player,
      racingSnapshot.race,
      racingSnapshot.session,
      racingSnapshot.crew,
      racingSnapshot.waypoints,
      normalizedArgs,
    );
  }

  RacingSnapshotWithWaypoints get _snapshotWithWaypoints =>
      _lastSnapshotWithWaypoints;
  RacingSnapshot get _snapshot => (
        race: _snapshotWithWaypoints.race,
        session: _snapshotWithWaypoints.session,
        crew: _snapshotWithWaypoints.crew,
      );
  Waypoint get _waypoint =>
      _snapshotWithWaypoints.waypoints[_snapshot.crew.waypointId]!;
}

class ResponseCommand extends Command {
  @override
  void _onCommand(
    final Engine engine,
    final MessageService messageService,
    final Player player,
    final Race race,
    final Session session,
    final Crew crew,
    final Map<String, Waypoint> waypoints,
    final String args,
  ) {
    final response = args.toLowerCase();
    if (_waypoint.answers.contains(response)) {
      // yay
    } else {
      messageService.sendMessageFromRaceToCrew(
        _snapshot,
        '${player.name} responded with "$args", but that\'s not it!',
      );
    }
  }
}
