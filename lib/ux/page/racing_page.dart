import 'package:flutter/material.dart';

import '../../model/crew.dart';
import '../../model/race.dart';
import '../../model/session.dart';
import '../../model/waypoint.dart';

import '../../service/race_service.dart';
import '../../service/service_registry.dart';

import '../widget/async_builder_template.dart';
import '../widget/waypoint_widget.dart';

class RacingPage extends StatelessWidget {
  final Stream<RacingSnapshotWithWaypoints> _racingSnapshots;

  RacingPage(
    final RacingSnapshot racingSnapshot, {
    Key? key,
  }) : this.custom(
          ServiceRegistry.I.raceService,
          racingSnapshot,
          key: key,
        );

  RacingPage.custom(
    final RaceService raceService,
    final RacingSnapshot racingSnapshot, {
    super.key,
  }) : _racingSnapshots = raceService
            .getRacingStreamWithWaypointsByRaceAndSessionAndCrewAndCourse(
          racingSnapshot.race.id,
          racingSnapshot.session.id,
          racingSnapshot.crew.id,
          racingSnapshot.crew.courseId,
        );

  @override
  Widget build(BuildContext context) =>
      AsyncBuilderTemplate<RacingSnapshotWithWaypoints>(
        stream: _racingSnapshots,
        builder: (context, snapshot) => DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              title: Column(
                children: [
                  const SizedBox(
                    height: 30,
                  ),
                  Text(
                      '${snapshot!.race.name}: ${snapshot.race.tagLineOrDefault}'),
                  Text(
                    '${snapshot.session.name} / ${snapshot.crew.name}',
                    style: const TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
              bottom: const TabBar(
                tabs: [
                  Tab(
                    icon: Icon(Icons.directions_run),
                    text: 'Race',
                  ),
                  Tab(
//mark_chat_unread
                    icon: Icon(Icons.chat_bubble),
                    text: 'Messages',
                  ),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                gamingWidget(
                  context,
                  snapshot.race,
                  snapshot.session,
                  snapshot.crew,
                  snapshot.waypoints,
                ),
                const Icon(Icons.message),
              ],
            ),
          ),
        ),
      );

  Widget gamingWidget(
    final BuildContext context,
    final Race race,
    final Session session,
    final Crew crew,
    final Map<String, Waypoint> waypoints,
  ) =>
      Container(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 35.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            WaypointWidget(waypoints[crew.waypointId]!),
            const SizedBox(
              height: 50.0,
            ),
            Text(
              'RESPONSE',
              style: TextStyle(
                color: Theme.of(context).primaryColorDark,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 2.0,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            const TextField(
              decoration: InputDecoration(
                filled: true,
              ),
              style: TextStyle(
                fontSize: 24,
              ),
            ),
            const SizedBox(
              height: 25.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  child: const Text('SUBMIT'),
                  onPressed: () => {},
                ),
              ],
            ),
          ],
        ),
      );

  //Widget messagingWidget(final BuildContext context) =>
}
