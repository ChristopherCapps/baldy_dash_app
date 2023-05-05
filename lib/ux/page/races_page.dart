import 'package:flutter/material.dart';

import '../../engine.dart';
import '../../model/race.dart';
import '../../service/race_service.dart';
import '../page/sessions_page.dart';
import '../widget/error_message_widget.dart';
import '../widget/loading_widget.dart';
import '../widget/race_tile_widget.dart';

class RacesPage extends StatelessWidget {
  final RaceService raceService;
  final Engine engine;

  const RacesPage({
    super.key,
    required this.raceService,
    required this.engine,
  });

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
              Expanded(
                child: ListView.builder(
                  itemCount: races.length,
                  itemBuilder: (context, index) => RaceTileWidget(
                    races[index],
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SessionsPage(
                            raceService: raceService, race: races[index]),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
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
