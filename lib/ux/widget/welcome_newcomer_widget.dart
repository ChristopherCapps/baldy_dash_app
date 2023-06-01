import 'package:flutter/material.dart';

import '../../service/player_service.dart';
import '../../service/service_registry.dart';
import '../page/races_page.dart';
import 'name_prompt_widget.dart';

class WelcomeNewcomerWidget extends StatelessWidget {
  final PlayerService _playerService;

  WelcomeNewcomerWidget({Key? key})
      : this.custom(ServiceRegistry.I.playerService, key: key);

  const WelcomeNewcomerWidget.custom(this._playerService, {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Welcome, new Dasher!'),
        ),
        body: Container(
          padding: const EdgeInsets.only(left: 30.0, right: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'We\'re so glad you\'re here!',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                'To get started, we just need to know the name we\'ll use to address you. This will also be how you\'re mentioned to your crew and to the opposing crew.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
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

  Future<void> _createNewPlayer(final String name) async => _playerService
      .getPlayer()
      .then((player) => player.copyWith(name: name))
      .then(_playerService.updatePlayer);
}
