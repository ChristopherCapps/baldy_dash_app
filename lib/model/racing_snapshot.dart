import '../model/crew.dart';
import '../model/race.dart';
import '../model/session.dart';
import '../model/waypoint.dart';

typedef RacingSnapshot = ({Race race, Session session, Crew crew});

typedef RacingSnapshotWithWaypoints = ({
  Race race,
  Session session,
  Crew crew,
  Map<String, Waypoint> waypoints,
});
