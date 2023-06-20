import 'package:flutter/material.dart';

import '../../model/waypoint.dart';

@immutable
class WaypointWidget extends StatefulWidget {
  final Waypoint _waypoint;
  final ValueChanged<String> _onResponse;

  const WaypointWidget(this._waypoint, this._onResponse, {super.key});

  @override
  State<WaypointWidget> createState() => _WaypointWidget();
}

class _WaypointWidget extends State<WaypointWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onSubmitted(final String text) {
    _controller.clear();
    widget._onResponse(text);
  }

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
                    widget._waypoint.id,
                    style: const TextStyle(fontSize: 36),
                  ),
                ],
              ),
              trailing: Text(
                '${widget._waypoint.region}',
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
                  widget._waypoint.clue,
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
                TextField(
                  controller: _controller,
                  onSubmitted: _onSubmitted,
                  decoration: const InputDecoration(
                    //filled: true,
                    border: UnderlineInputBorder(),
                  ),
                  style: const TextStyle(
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
                      onPressed: () => _onSubmitted(_controller.text),
                      child: const Text('SUBMIT'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
}
