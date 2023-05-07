import 'crew.dart';
import 'race.dart';
import 'session.dart';
import 'waypoint.dart';

class GamingSnapshot {
  final Race race;
  final Session session;
  final Crew crew;
  final Map<String, Waypoint> waypoints;

  GamingSnapshot(this.race, this.session, this.crew, this.waypoints);
}
