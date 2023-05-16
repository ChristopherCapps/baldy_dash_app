import 'package:flutter/material.dart';

import '../../engine.dart';
import '../../model/race.dart';
import '../../model/session.dart';
import '../../service/race_service.dart';
import '../widget/async_builder_template.dart';
import 'crews_page.dart';

class SessionsPage extends StatelessWidget {
  final Race race;
  final RaceService raceService;

  const SessionsPage(
      {super.key, required this.raceService, required this.race});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(race.name),
              Text(race.tagLineOrDefault,
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
                child: sessionsWidget(),
              ),
            ],
          ),
        ),
      );

  AsyncBuilderTemplate<List<Session>> sessionsWidget() =>
      AsyncBuilderTemplate<List<Session>>(
        stream: raceService.getSessions(race),
        builder: (context, sessions) {
          if (sessions!.isEmpty) {
            return const Text('No sessions are available for this race.');
          }
          return Column(
            children: [
              banner(),
              Expanded(
                child: ListView.builder(
                  itemCount: sessions.length,
                  itemBuilder: (context, index) =>
                      sessionListTile(context, sessions[index]),
                ),
              ),
            ],
          );
        },
      );

  ListTile sessionListTile(BuildContext context, Session session) {
    print('Render session: $session');
    return ListTile(
      //enabled: true,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CrewsPage(
            engine: Engine.I,
            raceService: raceService,
            race: race,
            session: session,
          ),
        ),
      ),
      title: Text(session.name),
      subtitle: Text(session.tagLineOrDefault),
      trailing: _sessionStatusWidget(session),
    );
  }

  Column _sessionStatusWidget(final Session session) => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            {
              SessionState.paused: 'PAUSED',
              SessionState.completed: 'COMPLETED',
              SessionState.pending: 'STARTING SOON',
              SessionState.running: 'HAPPENING NOW!'
            }[session.state]!,
          ),
          Text('Started 23 minutes ago')
        ],
      );

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
              'Select an available session to join.',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
}
