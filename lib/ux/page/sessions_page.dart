import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../engine.dart';
import '../../model/race.dart';
import '../../model/session.dart';
import '../../service/race_service.dart';
import '../../service/service_registry.dart';
import '../widget/async_builder_template.dart';
import 'crews_page.dart';

class SessionsPage extends StatelessWidget {
  final Race _race;
  final Engine _engine;
  final RaceService _raceService;

  SessionsPage(final Race race, {Key? key})
      : this.custom(Engine.I, ServiceRegistry.I.raceService, race, key: key);

  const SessionsPage.custom(this._engine, this._raceService, this._race,
      {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              Text(_race.name),
              Text(_race.tagLineOrDefault,
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
        stream: _raceService.getSessions(_race),
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
                  itemBuilder: (context, index) => FutureBuilder(
                    future: sessionListTile(context, sessions[index]),
                    builder: (context, sessionTileSnapshot) =>
                        sessionTileSnapshot.hasData
                            ? sessionTileSnapshot.data!
                            : const Text('Loading...'),
                  ),
                ),
              ),
            ],
          );
        },
      );

  Future<ListTile> sessionListTile(
      BuildContext context, Session session) async {
    print('Render session: $session');
    return ListTile(
      enabled: session.state != SessionState.completed,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => CrewsPage(_race, session),
        ),
      ),
      title: Text(session.name),
      subtitle: Text(session.tagLineOrDefault),
      trailing: await _sessionStatusWidget(session),
    );
  }

  Future<Column> _sessionStatusWidget(final Session session) async => Column(
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
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(switch (session.state) {
            SessionState.paused ||
            SessionState.running =>
              'Started at ${DateFormat('jm').format(session.startTime!)}',
            SessionState.completed => await _completedText(session),
            SessionState.pending => 'Get Ready!',
          }),
        ],
      );

  Future<String> _completedText(final Session session) async => _engine
      .getWinningCrew(session)
      .then((crew) => crew != null ? 'Won by ${crew.name}' : 'Unknown winner');

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
