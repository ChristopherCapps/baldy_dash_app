import 'package:flutter/material.dart';
import '../../model/race.dart';
import '../../model/session.dart';

class ReadyPage extends StatelessWidget {
  final Race _race;
  final Session _session;

  const ReadyPage(this._race, this._session, {super.key});

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
          child: const Text('Prepare yourself...'),
        ),
      );
}
