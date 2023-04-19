import 'package:flutter/material.dart';

import './races_page.dart';
import '../../engine.dart';
import '../../model/player.dart';
import '../../service/race_service.dart';
import '../widget/error_message_widget.dart';
import '../widget/name_prompt_widget.dart';

class WelcomePage extends StatelessWidget {
  final RaceService raceService;

  const WelcomePage(this.raceService, {super.key});

  @override
  Widget build(BuildContext context) => Container(
        child: FutureBuilder(
          future: raceService.getPlayer(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return ErrorMessageWidget.withDefaults(
                details:
                    'We weren\'t able to initialize the app. ${snapshot.error}',
              );
            }
            final player = snapshot.data;
            if (player != null) {
              return _welcomeBack(context, player);
            }
            return _welcomeNewcomer(context);
          },
        ),
      );

  Widget _racesPage(final Player player) => RacesPage(
        raceService: raceService,
        engine: Engine.initialize(player),
      );

  Widget _welcomeBack(final BuildContext context, final Player player) =>
      Scaffold(
        appBar: AppBar(
          title: const Text('Welcome back, dasher!'),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text('We\'re glad to see you again, ${player.name}.'),
              ),
              textNotificationForInProgressSession(player),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => _racesPage(player)),
                ),
                child: Text('LET\'S PLAY!'),
              )
            ],
          ),
        ),
      );

  Future<Player> _createNewPlayer(final String name) async {
    final role =
        name.toUpperCase() == 'GM' ? Role.gamemaster : Role.participant;
    final normalizedName =
        role == Role.gamemaster ? 'Master Chris' : name.trim();
    return await raceService.createPlayer(
      role,
      normalizedName,
    );
  }

  Widget _welcomeNewcomer(final BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Welcome, new Dasher!'),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'We\'re so glad you\'re here!',
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              const Text(
                '''To get started, we just need to know the name we'll 
                use to address you.\nThis will also be how you're mentioned
                to your crew and to the opposing crew.''',
                textAlign: TextAlign.center,
              ),
              NamePromptWidget(
                onSubmitted: (name) async {
                  final player = await _createNewPlayer(name);
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => _racesPage(player)),
                  );
                },
              ),
            ],
          ),
        ),
      );
      
        textNotificationForInProgressSession(final Player player) {
          if (player.sessionId != null) {
            final session = raceService.getSessions
            return Text('It appears that you\'re already running in a race')
          }
        }
}
