import 'package:flutter/material.dart';

import '../../engine.dart';

import '../../model/crew.dart';
import '../../model/message.dart';
import '../../model/player.dart';
import '../../model/race.dart';
import '../../model/session.dart';
import '../../model/waypoint.dart';

import '../../service/race_service.dart';
import '../../service/service_registry.dart';

import '../widget/async_builder_template.dart';
import '../widget/message_widget.dart';
import '../widget/waypoint_widget.dart';

class RacingPage extends StatelessWidget {
  final Engine _engine;
  final Stream<RacingSnapshotWithWaypoints> _racingSnapshots;

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
                _messageListWidget(context, _engine.player, snapshot.crew),
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
          ],
        ),
      );

  final List<Message> _messages = [
    Message(
      '1',
      '1',
      sendingPlayerId: '1',
      messageSenderType: MessageSenderType.player,
      messageReceiverType: MessageReceiverType.player,
      receivingPlayerId: '2',
      timestamp: DateTime.now(),
      text:
          'Our crew guesses \'rosebud\' for this clue. Are we right? I dont know but I want to see how long this text can get.',
    ),
  ];

  Widget _messageListWidget(
          final BuildContext context, final Player player, final Crew crew) =>
      ListView.builder(
        itemCount: _messages.length,
        itemBuilder: (context, index) =>
            _buildMessageWidget(context, player, crew, _messages[index]),
      );

  Widget? _buildMessageWidget(final BuildContext context, final Player player,
          final Crew crew, final Message message) =>
      // We want to show the message in this player's feed ONLY if it was
      // targeted to the player's crew, or if it was directly sent to the player
      switch (message.messageReceiverType) {
        MessageReceiverType.crew when message.receivingPlayerId == crew.id =>
          MessageWidget(message),
        MessageReceiverType.player
            when message.receivingPlayerId == player.id =>
          MessageWidget(message),
        _ => null,
      };
}
