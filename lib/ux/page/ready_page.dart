import 'package:flutter/material.dart';

import '../../model/crew.dart';
import '../../model/race.dart';
import '../../model/session.dart';
import '../../service/race_service.dart';

import '../widget/error_message_widget.dart';
import '../widget/loading_widget.dart';

class ReadyPage extends StatelessWidget {
  final RaceService _raceService;
  final Race _race;
  final Session _session;
  final Crew _crew;

  const ReadyPage(this._raceService, this._race, this._session, this._crew,
      {super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Column(
            children: [
              const Text('Ready Room'),
              Text(
                '${_race.name} / ${_session.name}',
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        body: Container(
            padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 35.0),
            child: StreamBuilder<Session>(
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return ErrorMessageWidget.withDefaults(
                      details: snapshot.error!.toString());
                }
                if (!snapshot.hasData) {
                  return const LoadingWidget();
                }
                final session = snapshot.data!;
                if (session.state == SessionState.completed) {
                  return const Text('This race has ended.');
                }
                return const Text('Race about to start');
              },
              stream: _raceService.getSessionStreamById(_race.id, _session.id),
            )),
      );
}
