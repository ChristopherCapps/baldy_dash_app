import 'package:flutter/material.dart';

import '../../model/player.dart';

import '../../service/race_service.dart';
import '../../service/service_registry.dart';

import '../page/races_page.dart';
import 'name_prompt_widget.dart';

class WelcomeNewcomerWidget extends StatelessWidget {
  final RaceService _raceService;

  WelcomeNewcomerWidget({Key? key})
      : this.custom(ServiceRegistry.I.raceService, key: key);

  const WelcomeNewcomerWidget.custom(this._raceService, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
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
                  await _createNewPlayer(name);
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => _racesPage()),
                  );
                },
              ),
            ],
          ),
        ),
      );

  Widget _racesPage() => RacesPage();

  Future<Player> _createNewPlayer(final String name) async =>
      await _raceService.createPlayer(
        Role.participant,
        name,
      );
}
