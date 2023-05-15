import 'package:flutter/material.dart';

import '../../model/session.dart';
import '../../service/race_service.dart';

import '../../service/service_registry.dart';

class ReadyPage extends StatefulWidget {
  final RaceService _raceService;
  final RacingSnapshot _racingSnapshot;

  ReadyPage(final RacingSnapshot racingSnapshot, {Key? key})
      : this.custom(ServiceRegistry.I.raceService, racingSnapshot, key: key);

  const ReadyPage.custom(this._raceService, this._racingSnapshot, {super.key});

  @override
  State<StatefulWidget> createState() => _ReadyPageState();
}

class _ReadyPageState extends State<ReadyPage> {
  late RacingSnapshot _racingSnapshot;
  late final Stream<RacingSnapshot> _racingStream;

  @override
  void initState() {
    super.initState();
    _racingSnapshot = widget._racingSnapshot;
    _racingStream = widget._raceService.getRacingStreamByRaceAndSessionAndCrew(
      _racingSnapshot.race.id,
      _racingSnapshot.session.id,
      _racingSnapshot.crew.id,
    );
    _racingStream.listen(
      (racingSnapshot) => setState(() => _racingSnapshot = racingSnapshot),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              const Text('Ready Room'),
              Text(
                '${_racingSnapshot.race.name} / ${_racingSnapshot.session.name}',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 35.0),
          child: (_racingSnapshot.session.state == SessionState.completed)
              ? const Text('This race has ended.')
              : (_racingSnapshot.session.state == SessionState.running)
                  ? const Text('This race is currently running.')
                  : const Text('Race about to start'),
        ),
      );
}
