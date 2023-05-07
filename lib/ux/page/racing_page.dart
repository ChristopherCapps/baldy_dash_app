import 'package:flutter/material.dart';

import '../../model/gaming_snapshot.dart';

import '../../service/race_service.dart';

class RacingPage extends StatelessWidget {
  final Stream<GamingSnapshot> _gamingSnapshots;

  RacingPage(
    final RaceService raceService,
    final String raceId,
    final String sessionId,
    final String crewId,
    final String courseId,
  ) : _gamingSnapshots = raceService.getGamingStreamById(
          raceId,
          sessionId,
          crewId,
          courseId,
        );

  @override
  Widget build(BuildContext context) => StreamBuilder(
    stream: _gamingSnapshots,
    builder: 
  Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(race.name),
              Text(session.name,
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
              Expanded(
                child: crewsWidget(),
              ),
            ],
          ),
        ),
      );
}
