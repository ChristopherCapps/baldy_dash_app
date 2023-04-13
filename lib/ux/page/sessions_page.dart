import 'package:flutter/material.dart';

import '../../model/race.dart';
import '../../model/session.dart';
import '../../service/race_service.dart';
import '../widget/error_message_widget.dart';
import '../widget/loading_widget.dart';

class SessionsPage extends StatelessWidget {
  final Race race;
  final RaceService raceService;

  const SessionsPage(
      {super.key, required this.raceService, required this.race});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(race.name)),
        body: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              sessionsWidget(),
            ],
          ),
        ),
      );

  StreamBuilder<List<Session>> sessionsWidget() => StreamBuilder<List<Session>>(
        stream: raceService.getSessions(race),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorMessageWidget.withDefaults(
                details: snapshot.error!.toString());
          }
          if (!snapshot.hasData) {
            return const LoadingWidget();
          }
          final sessions = snapshot.data!;
          if (sessions.isEmpty) {
            return const Text('No sessions are available for this race.');
          }
          // return Text("Test");
          return Column(
            children: [
              banner(),
              ListView.builder(
                itemCount: sessions.length,
                itemBuilder: (context, index) =>
                    sessionListTile(context, sessions[index]),
              ),
            ],
          );
        },
      );

  ListTile sessionListTile(BuildContext context, Session session) {
    print('Render session: $session');
    return ListTile(
      // enabled: session.available,
      // onTap: () => Navigator.of(context).push(
      //   MaterialPageRoute(
      //     builder: (context) => SessionsPage(race: race),
      //   ),
      // ),
      title: Text(session.name),
      subtitle: Text(race.tagline ?? 'The adventure awaits!'),
    );
  }

  static const defaultRaceUrl =
      'https://quest-baldy-dash.web.app/images/Old-Baldy-p-500.jpg';

  CircleAvatar raceLogo(final Race race) => CircleAvatar(
        backgroundImage: NetworkImage(race.logoUrl ?? defaultRaceUrl),
        //foregroundImage: NetworkImage(race.logoUrl ?? defaultRaceUrl),
        //child: const Text('BD'),
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
