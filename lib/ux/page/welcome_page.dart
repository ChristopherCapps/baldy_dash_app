import 'package:flutter/material.dart';

import './races_page.dart';
import '../../engine.dart';
import '../../model/player.dart';
import '../../model/race.dart';
import '../../model/session.dart';
import '../../service/race_service.dart';
import '../widget/error_message_widget.dart';
import '../widget/loading_widget.dart';
import '../widget/name_prompt_widget.dart';
import '../widget/race_tile_widget.dart';
import 'ready_page.dart';

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
            if ((snapshot.connectionState == ConnectionState.active ||
                    snapshot.connectionState == ConnectionState.done) &&
                snapshot.hasData) {
              final player = snapshot.data!;
              if (player.name != Player.newPlayerName) {
                return _welcomeBack(context, player);
              }
              return _welcomeNewcomer(context);
            } else {
              return const LoadingWidget();
            }
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
              Text('We\'re glad to see you again, ${player.name}.'),
              WelcomeBackWidget(
                raceService,
                player,
              ),
              ElevatedButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => _racesPage(player)),
                ),
                child: const Text('LET\'S PLAY!'),
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
                  await Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => _racesPage(player)),
                  );
                },
              ),
            ],
          ),
        ),
      );
}

class WelcomeBackWidget extends StatefulWidget {
  final RaceService raceService;
  final Player player;

  const WelcomeBackWidget(this.raceService, this.player, {super.key});

  @override
  State<StatefulWidget> createState() => _WelcomeBackWidget();
}

class _WelcomeBackWidget extends State<WelcomeBackWidget> {
  Session? _priorSession;

  _WelcomeBackWidget();

  @override
  void initState() {
    super.initState();
    if (widget.player.sessionId != null) {
      final session = widget.raceService.getSessionStreamById(
        widget.player.raceId!,
        widget.player.sessionId!,
      );
      session.listen(
        (session) {
          setState(() {
            _priorSession = session;
          });
        },
        cancelOnError: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_priorSession != null) {
      return Container(
        padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                '''Looks like you were last participating in this race, which ${_getPriorSessionStatusText(_priorSession!.state)}'''),
            FutureBuilder<Race>(
              future: widget.raceService.getRaceById(widget.player.raceId!),
              builder: (context, snapshot) => snapshot.hasData
                  ? Column(
                      children: [
                        RaceTileWidget(snapshot.data!),
                        _resumeSessionButton(snapshot.data!, _priorSession!),
                      ],
                    )
                  : snapshot.hasError
                      ? ErrorMessageWidget.withDefaults(
                          details: snapshot.error.toString(),
                        )
                      : const LoadingWidget(),
            ),
          ],
        ),
      );
    } else {
      return const Text('Looks like you\'re about to run your first race!');
    }
  }

  String? _getPriorSessionStatusText(final SessionState state) => {
        SessionState.pending: 'will be starting soon.',
        SessionState.paused: 'has been paused by the gamemaster.',
        SessionState.completed: 'has completed already.',
        SessionState.running: 'is still underway!'
      }[state];

  Widget _resumeSessionButton(final Race race, final Session priorSession) =>
      ElevatedButton(
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => _readyPage(race, priorSession)),
          );
        },
        child: const Text('REJOIN NOW'),
      );

  Widget _readyPage(final Race race, final Session priorSession) =>
      ReadyPage(widget.raceService, race, priorSession);
}
