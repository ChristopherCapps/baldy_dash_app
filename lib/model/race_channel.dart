import '../model/crew.dart';
import '../model/race.dart';
import '../model/session.dart';
import '../model/waypoint.dart';

typedef RaceChannel = ({String raceId, String sessionId, String crewId});

typedef RaceChannelSnapshot = ({
  Race race,
  Session session,
  Crew crew,
  Map<String, Waypoint> waypoints,
});

// Add these to Engine concept?