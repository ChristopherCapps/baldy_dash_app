import 'package:flutter/material.dart';

import '../../engine.dart';
import '../../model/race.dart';
import '../../service/race_service.dart';
import '../../service/service_registry.dart';
import '../page/sessions_page.dart';
import '../widget/async_builder_template.dart';
import '../widget/race_tile_widget.dart';

class RacesPage extends StatelessWidget {
  final RaceService raceService;
  final Engine engine;

  RacesPage({Key? key})
      : this.custom(ServiceRegistry.I.raceService, Engine.I, key: key);

  const RacesPage.custom(
    this.raceService,
    this.engine, {
    super.key,
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

  AsyncBuilderTemplate<List<Race>> racesWidget() =>
      AsyncBuilderTemplate<List<Race>>(
        stream: raceService.getRaces(),
        builder: (context, races) {
          if (races!.isEmpty) {
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
        child: const Column(
          children: [
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
