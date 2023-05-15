import 'package:flutter/material.dart';

import '../../model/crew.dart';
import '../../model/race.dart';
import '../../model/session.dart';
import '../../model/waypoint.dart';

import '../../service/race_service.dart';
import '../../service/service_registry.dart';

import '../widget/error_message_widget.dart';
import '../widget/loading_widget.dart';

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
  Widget build(BuildContext context) => StreamBuilder(
      stream: _racingSnapshots,
      builder: (context, snapshot) => snapshot.hasData
          ? gamingWidget(
              snapshot.data!.race,
              snapshot.data!.session,
              snapshot.data!.crew,
              snapshot.data!.waypoints,
            )
          : snapshot.hasError
              ? errorWidget(snapshot.error!)
              : loadingWidget());

  Widget gamingWidget(
    final Race race,
    final Session session,
    final Crew crew,
    final Map<String, Waypoint> waypoints,
  ) =>
      Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(race.name),
              Text(session.name,
                  style: const TextStyle(
                    fontSize: 12,
                  )),
              Text(crew.name,
                  style: const TextStyle(
                    fontSize: 12,
                  )),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: Text(waypoints[crew.waypointId]!.clue)),
            ],
          ),
        ),
      );

  Widget errorWidget(Object error) =>
      ErrorMessageWidget.withDefaults(error.toString());

  Widget loadingWidget() => const LoadingWidget();
}
