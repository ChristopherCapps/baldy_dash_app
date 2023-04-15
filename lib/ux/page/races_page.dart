import 'package:flutter/material.dart';

import '../../model/race.dart';
import '../../service/race_service.dart';
import '../page/sessions_page.dart';
import '../widget/error_message_widget.dart';
import '../widget/loading_widget.dart';

class RacesPage extends StatelessWidget {
  final RaceService raceService;

  const RacesPage({super.key, required this.raceService});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Lobby')),
        body: Container(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, top: 35.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: racesWidget(),
              ),
            ],
          ),
        ),
      );

  StreamBuilder<List<Race>> racesWidget() => StreamBuilder<List<Race>>(
        stream: raceService.getRaces(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return ErrorMessageWidget.withDefaults(
                details: snapshot.error!.toString());
          }
          if (!snapshot.hasData) {
            return const LoadingWidget();
          }
          final races = snapshot.data!;
          if (races.isEmpty) {
            return const Text('No races are available');
          }
          return Column(
            children: [
              banner(),
              //Image.network(defaultRaceUrl, fit: BoxFit.contain),
              Expanded(
                child: ListView.builder(
                  itemCount: races.length,
                  itemBuilder: (context, index) =>
                      raceListTile(context, races[index]),
                ),
              ),
            ],
          );
        },
      );

  ListTile raceListTile(BuildContext context, Race race) {
    print('Render race: $race');
    return ListTile(
      enabled: race.available,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              SessionsPage(raceService: raceService, race: race),
        ),
      ),
      title: Text(race.name),
      subtitle: Text(race.tagLineOrDefault),
      leading: raceLogo(race),
      trailing: race.available
          ? const Icon(
              Icons.verified,
              color: Colors.green,
            )
          : null,
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
              'Select the race you\'d like to run.',
              style: TextStyle(
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ),
      );
}
