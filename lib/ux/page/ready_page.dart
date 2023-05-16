import 'package:flutter/material.dart';

import '../../model/session.dart';
import '../../service/race_service.dart';
import '../../service/service_registry.dart';
import '../widget/async_builder_template.dart';
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
        builder: (context, racingSnapshot) {
          if (racingSnapshot!.session.state == SessionState.running) {
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => RacingPage(racingSnapshot)));
            return Container();
          } else {
            return Scaffold(
              appBar: AppBar(
                title: Column(
                  children: [
                    const Text('Ready Room'),
                    Text(
                      '${racingSnapshot.race.name} / ${racingSnapshot.session.name}',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              body: Container(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 20.0, top: 35.0),
                child: (_racingSnapshot.session.state == SessionState.completed)
                    ? const Text('This race has ended.')
                    : (_racingSnapshot.session.state == SessionState.running)
                        ? const Text('This race is currently running.')
                        : const Text('Race about to start'),
              ),
            );
          }
        },
      );
}
