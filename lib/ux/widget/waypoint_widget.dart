import 'package:flutter/material.dart';

import '../../model/waypoint.dart';

@immutable
class WaypointWidget extends StatelessWidget {
  final Waypoint _waypoint;

  const WaypointWidget(this._waypoint, {super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(5.0, 0, 5.0, 0.0),
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              color: Colors.teal,
            ),
            child: ListTile(
              title: Row(
                children: [
                  const Text(
                    'WAYPOINT',
                    style: TextStyle(fontSize: 24),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Text(
                    _waypoint.id,
                    style: const TextStyle(fontSize: 36),
                  ),
                ],
              ),
              trailing: Text(
                '${_waypoint.region}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 0.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CLUE',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Text(
                  _waypoint.clue,
                  style: const TextStyle(
                    fontSize: 18.0,
                  ),
                ),
                const SizedBox(
                  height: 50.0,
                ),
                Text(
                  'RESPONSE',
                  style: TextStyle(
                    color: Theme.of(context).primaryColorDark,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                const TextField(
                  decoration: InputDecoration(
                    filled: true,
                    border: UnderlineInputBorder(),
                  ),
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(
                  height: 25.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: const Text('SUBMIT'),
                      onPressed: () => {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}
