import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../engine.dart';
import '../../model/player.dart';
import '../../model/session.dart';
import '../../service/race_service.dart';
import '../../service/service_registry.dart';

import '../page/races_page.dart';
import '../page/racing_page.dart';
import '../page/ready_page.dart';

import 'async_builder_template.dart';
import 'race_tile_widget.dart';

class WelcomeBackWidget extends StatelessWidget {
  final RaceService _raceService;
  final Engine _engine;

  WelcomeBackWidget({Key? key})
      : this.custom(Engine.I, ServiceRegistry.I.raceService, key: key);

  const WelcomeBackWidget.custom(this._engine, this._raceService, {super.key});

  Player get _player => _engine.player;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Welcome back, dasher!'),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('We\'re glad to see you again, ${_player.name}.'),
              _player.crewPath != null
                  ? _buildPriorSessionWidget()
                  : _buildPriorVisitWidget(context),
            ],
          ),
        ),
      );

  Widget _buildPriorVisitWidget(final BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Looks like you need to join a race!'),
          _letsPlayButton(context),
        ],
      );

  Widget _buildPriorSessionWidget() {
    final crewPath = _raceService.getDecomposedCrewPath(_player.crewPath!);

    return AsyncBuilderTemplate<RacingSnapshot>(
      stream: _raceService.getRacingStreamByRaceAndSessionAndCrew(
        crewPath.raceId,
        crewPath.sessionId,
        crewPath.crewId,
      ),
      builder: (context, racingSnapshot) => Column(
        children: [
          const Text('It looks like you were last running this race:'),
          RaceTileWidget(racingSnapshot!.race),
          switch (racingSnapshot.session.state) {
            SessionState.completed =>
              _buildCompletedPriorSessionWidget(racingSnapshot),
            SessionState.paused ||
            SessionState.running =>
              _buildActivePriorSessionWidget(context, racingSnapshot),
            SessionState.pending =>
              _buildPendingPriorSessionWidget(context, racingSnapshot),
          },
        ],
      ),
    );
  }

  Widget _buildCompletedPriorSessionWidget(RacingSnapshot snapshot) =>
      AsyncBuilderTemplate(
        future: _engine.getWinningCrew(snapshot.session),
        builder: (context, crew) => Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('''
              This race finished at 
              ${DateFormat("MMMM d, y").format(snapshot.session.completedTime!)} 
              ${crew != null ? "and was won by ${crew.name}" : "but the winner hasn't been recorded"}.'''),
            _letsPlayButton(context),
          ],
        ),
      );

  Widget _buildActivePriorSessionWidget(
          final BuildContext context, final RacingSnapshot racingSnapshot) =>
      Column(
        children: [
          const Text(
              'It looks like you were last running this race, which is still underway!'),
          RaceTileWidget(racingSnapshot.race),
          Text('''You have joined the ${racingSnapshot.session.name} session 
              as a member of the "${racingSnapshot.crew.name}" crew.'''),
          _rejoinRaceButton(context, () => RacingPage(racingSnapshot)),
        ],
      );

  Widget _buildPendingPriorSessionWidget(
          final BuildContext context, final RacingSnapshot racingSnapshot) =>
      Column(
        children: [
          const Text(
              'It looks like you were last preparing to run this race, which has not yet started.'),
          RaceTileWidget(racingSnapshot.race),
          Text('''You have joined the ${racingSnapshot.session.name} session 
              as a member of the "${racingSnapshot.crew.name}" crew.'''),
          _rejoinRaceButton(context, () => ReadyPage(racingSnapshot))
        ],
      );

  Widget _letsPlayButton(final BuildContext context) => ElevatedButton(
        onPressed: () async => await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => RacesPage())),
        child: const Text('LET\'S PLAY!'),
      );

  Widget _rejoinRaceButton(
          final BuildContext context, final Widget Function() buttonTargetFx) =>
      ElevatedButton(
        onPressed: () async => await Navigator.of(context)
            .push(MaterialPageRoute(builder: (context) => buttonTargetFx())),
        child: const Text('REJOIN NOW'),
      );
}