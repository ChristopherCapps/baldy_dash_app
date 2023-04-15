import 'package:flutter/material.dart';

import '../../model/crew.dart';
import '../../model/race.dart';
import '../../model/session.dart';
import '../../service/race_service.dart';
import '../widget/error_message_widget.dart';
import '../widget/loading_widget.dart';

class CrewsPage extends StatelessWidget {
  final Race race;
  final Session session;
  final RaceService raceService;

  const CrewsPage(
      {super.key,
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

  StreamBuilder<List<Crew>> crewsWidget() => StreamBuilder<List<Crew>>(
        stream: raceService.getCrews(race, session),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorMessageWidget.withDefaults(
                details: snapshot.error!.toString());
          }
          if (!snapshot.hasData) {
            return const LoadingWidget();
          }
          final crews = snapshot.data!;
          if (crews.isEmpty) {
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

  StreamBuilder crewListTile(BuildContext context, Crew crew) {
    print('Render crew: $crew');
    return StreamBuilder<Future<String>>(
      stream: _getPlayersForCrew(crew),
      builder: (_, futurePlayersList) => FutureBuilder<String>(
        future: futurePlayersList.data,
        builder: (_, playersList) => ListTile(
          // enabled: session.available,
          // onTap: () => Navigator.of(context).push(
          //   MaterialPageRoute(
          //     builder: (context) => SessionsPage(race: race),
          //   ),
          // ),
          title: Text(crew.name),
          subtitle: Text(playersList.data ?? ''),
          //trailing: const Text('PENDING'),
        ),
      ),
    );
  }

  Container banner() => Container(
        padding: const EdgeInsets.only(bottom: 18.0),
        child: Column(
          children: const [
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

  Stream<Future<String>> _getPlayersForCrew(final Crew crew) =>
      raceService.getCrew(race, session, crew).map(
            (crew) => crew.players.fold(Future(() => ''),
                (futureListOfPlayerNames, playerId) async {
              final player = await raceService.getPlayer(playerId);
              final listOfNames = await futureListOfPlayerNames;
              return '$listOfNames, ${player!.name!}';
            }),
          );
}
