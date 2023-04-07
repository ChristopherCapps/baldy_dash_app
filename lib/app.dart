import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'model/race.dart';
import 'service/service_registry.dart';

class BaldyDashApp extends StatelessWidget {
  const BaldyDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    // This app is designed only to work vertically, so we limit
    // orientations to portrait up and down.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
      routes: <String, WidgetBuilder>{
        '/': (BuildContext context) => Scaffold(
              appBar: AppBar(title: const Text('Lobby')),
              body: Container(
                child: racesWidget(),
              ),
            ),
        '/about': (BuildContext context) => Scaffold(
              appBar: AppBar(
                title: const Text('Race'),
              ),
            )
      },
    );
  }

  StreamBuilder<List<Race>> racesWidget() => StreamBuilder<List<Race>>(
        stream: ServiceRegistry.I.raceService.getRaces(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text('Loading...');
          }
          final races = snapshot.data!;
          if (races.isEmpty) {
            return const Text('No races are available');
          }
          return ListView.builder(
            itemCount: races.length,
            itemBuilder: (context, index) =>
                raceListTile(context, races[index]),
          );
        },
      );

  ListTile raceListTile(BuildContext context, Race race) {
    print('Render race: $race');
    return ListTile(
      title: Text(race.name),
      subtitle: const Text('Race for the cubes!'),
    );
  }
}
