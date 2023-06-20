import 'package:flutter/material.dart';

import '../../engine.dart';

import '../../model/command.dart';
import '../../model/crew.dart';
import '../../model/message.dart';
import '../../model/player.dart';
import '../../model/race.dart';
import '../../model/racing_snapshot.dart';
import '../../model/session.dart';
import '../../model/waypoint.dart';

import '../../service/race_service.dart';
import '../../service/service_registry.dart';

import '../widget/async_builder_template.dart';
import '../widget/messages_listview_widget.dart';
import '../widget/waypoint_widget.dart';

class RacingPage extends StatelessWidget {
  final Engine _engine;
  final Stream<RacingSnapshotWithWaypoints> _racingSnapshots;
  final Stream<List<Message>> _messages;

  RacingPage(
    final RacingSnapshot racingSnapshot, {
    Key? key,
  }) : this.custom(
          Engine.I,
          ServiceRegistry.I.raceService,
          racingSnapshot,
          key: key,
        );

  RacingPage.custom(
    this._engine,
    final RaceService raceService,
    final RacingSnapshot racingSnapshot, {
    super.key,
  })  : _racingSnapshots = raceService
            .getRacingStreamWithWaypointsByRaceAndSessionAndCrewAndCourse(
          racingSnapshot.race.id,
          racingSnapshot.session.id,
          racingSnapshot.crew.id,
          racingSnapshot.crew.courseId,
        ),
        _messages = raceService.getMessagesStream(
          racingSnapshot.race,
          racingSnapshot.session,
          racingSnapshot.crew,
        );

  @override
  Widget build(BuildContext context) =>
      AsyncBuilderTemplate<RacingSnapshotWithWaypoints>(
        stream: _racingSnapshots,
        builder: (context, snapshot) => DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              toolbarHeight: kToolbarHeight + 10.0,
              // title: Column(
              //   children: [
              //     const SizedBox(
              //       height: 30,
              //     ),
              //     Text(
              //         '${snapshot!.race.name}: ${snapshot.race.tagLineOrDefault}'),
              //     Text(
              //       '${snapshot.session.name} / ${snapshot.crew.name}',
              //       style: const TextStyle(
              //         fontSize: 12,
              //       ),
              //     ),
              //     const SizedBox(
              //       height: 20,
              //     ),
              //   ],
              // ),

              flexibleSpace: const SafeArea(
                child: TabBar(
                  padding: EdgeInsets.only(top: 10.0),
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
            ),
            body: TabBarView(
              children: [
                gamingWidget(
                  context,
                  snapshot!.race,
                  snapshot.session,
                  snapshot.crew,
                  snapshot.waypoints,
                ),
                _messagesWidget(context, _engine.player),
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
            WaypointWidget(
                waypoints[crew.waypointId]!,
                _onResponse((
                  race: race,
                  session: session,
                  crew: crew,
                  waypoints: waypoints,
                ))),
          ],
        ),
      );

  void Function(String) _onResponse(
          final RacingSnapshotWithWaypoints snapshotWithWaypoints) =>
      (String response) => _engine.handleCommand(
            snapshotWithWaypoints,
            ResponseCommand(),
            response,
          );

  List<Message> buildMessages(final Player player) => [
        Message.now(
          player.name.toUpperCase(),
          'Our crew guesses \'rosebud\' for this clue. Are we right? I dont know but I want to see how long this text can get.',
        ),
        Message.now(
          'BALDY DASH',
          'Sorry, Erin, but that\'s not the right answer! Try again.',
          toPlayerId: player.id,
        ),
        Message.now(
          'CARSON',
          'Team Girls is going down!',
        ),
        Message.now(
          player.name.toUpperCase(),
          'Our crew guesses \'rosebud\' for this clue. Are we right? I dont know but I want to see how long this text can get.',
        ),
        Message.now(
          'BALDY DASH',
          'Erin sent a taunt to the other crews: "Oh just shut it Carson!"',
          toPlayerId: player.id,
        ),
        Message.now(
          'GAME MASTER',
          'Don\'t make me pause the game for a sportsmanship lesson! :-P',
          toPlayerId: player.id,
        ),
      ];

  Widget _messagesWidget(final BuildContext context, final Player player) =>
      Container(
        padding: const EdgeInsets.only(bottom: 20.0),
        child: MessagesListViewWidget(player, _messages),
      );
}
