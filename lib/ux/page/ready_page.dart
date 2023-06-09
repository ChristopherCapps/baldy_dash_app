import 'package:flutter/material.dart';

import '../../model/racing_snapshot.dart';
import '../../model/session.dart';
import '../../service/race_service.dart';
import '../../service/service_registry.dart';
import '../widget/async_builder_template.dart';
import 'races_page.dart';
import 'racing_page.dart';

//races/vtGu6oxrs1uTYvb919VZ/sessions/Fa9RChhdixCljmSSEJl0/crews/86NgJJCq8KgexwcLzPga

class ReadyPage extends StatelessWidget {
  final RaceService _raceService;
  final RacingSnapshot _racingSnapshot;

  ReadyPage(final RacingSnapshot racingSnapshot, {Key? key})
      : this.custom(ServiceRegistry.I.raceService, racingSnapshot, key: key);

  const ReadyPage.custom(this._raceService, this._racingSnapshot, {super.key});

  @override
  Widget build(BuildContext context) => AsyncBuilderTemplate(
        stream: _raceService.getRacingStreamByRaceAndSessionAndCrew(
          _racingSnapshot.race.id,
          _racingSnapshot.session.id,
          _racingSnapshot.crew.id,
        ),
        builder: (context, racingSnapshot) => Scaffold(
          appBar: AppBar(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Ready Room'),
                Text(
                  '${racingSnapshot!.race.name} / ${racingSnapshot.session.name}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          body: Container(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 35.0),
            alignment: Alignment.center,
            child: Column(
              children: [
                Text(
                  {
                    SessionState.completed: 'This race has ended.',
                    SessionState.running: 'Time to race!',
                    SessionState.paused: 'This race is currently paused.',
                    SessionState.pending: 'This race is about to start.\n'
                        'When the it begins, the button below will light green.',
                  }[racingSnapshot.session.state]!,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                      ),
                      onPressed:
                          racingSnapshot.session.state == SessionState.running
                              ? () => Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RacingPage(racingSnapshot)))
                              : null,
                      child: const Text('LET\'S GO!'),
                    ),
                    const SizedBox(width: 15.0),
                    ElevatedButton(
                      onPressed:
                          racingSnapshot.session.state == SessionState.pending
                              ? () => Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                      builder: (context) => RacesPage()))
                              : null,
                      child: const Text('START OVER'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
