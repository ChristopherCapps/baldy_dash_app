import 'package:flutter/material.dart';

import '../../engine.dart';

import '../../model/crew.dart';
import '../../model/player.dart';
import '../../model/race.dart';
import '../../model/session.dart';
import '../../service/race_service.dart';
import '../widget/async_builder_template.dart';
import 'ready_page.dart';

class CrewsPage extends StatelessWidget {
  final Race race;
  final Session session;
  final Engine engine;
  final RaceService raceService;

  const CrewsPage(
      {super.key,
      required this.engine,
      required this.raceService,
      required this.race,
      required this.session});

  @override
  Widget build(BuildContext context) => Scaffold(
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

  AsyncBuilderTemplate<List<Crew>> crewsWidget() =>
      AsyncBuilderTemplate<List<Crew>>(
        stream: raceService.getCrews(race, session),
        builder: (context, crews) {
          if (crews!.isEmpty) {
            return const Text('No crews are available for this race.');
          }
          // return Text("Test");
          return Column(
            children: [
              banner(),
              Expanded(
                child: ListView.builder(
                  itemCount: crews.length,
                  itemBuilder: (context, index) =>
                      crewListTile(context, crews[index]),
                ),
              ),
            ],
          );
        },
      );

  AsyncBuilderTemplate<Crew> crewListTile(BuildContext context, Crew crew) {
    debugPrint('Render crew: $crew');
    return AsyncBuilderTemplate<Crew>(
      stream: raceService.getCrewStream(race, session, crew),
      builder: (context, crew) => AsyncBuilderTemplate<Set<Player>>(
        future: raceService.getPlayers(crew!),
        builder: (_, players) => ListTile(
          enabled: session.state == SessionState.pending ||
              session.state == SessionState.running,
          onTap: () {
            engine.assignPlayerToCrew(crew);
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    ReadyPage((race: race, session: session, crew: crew)),
              ),
            );
          },
          title: Text(crew.name),
          subtitle: Text(getListOfPlayerNames(players!)),
          //trailing: const Text('PENDING'),
        ),
      ),
    );
  }

  Container banner() => Container(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: const Column(
          children: [
            // Text(
            //   'Welcome!',
            //   style: TextStyle(
            //     fontSize: 18,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            Text(
              'Select a crew to join.',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );

  String getListOfPlayerNames(final Set<Player> players) {
    final playersList = [...players];
    if (players.isEmpty) {
      return 'Nobody has joined';
    } else if (playersList.length == 1) {
      return '${playersList[0].name} is the only member so far';
    } else if (playersList.length == 2) {
      return 'Just ${playersList[0].name} and ${playersList[1].name} so far';
    } else {
      return '${playersList.sublist(0, playersList.length - 1).map((playersList) => playersList.name).join(', ')} and ${playersList.reversed.first.name}';
    }
  }
}
