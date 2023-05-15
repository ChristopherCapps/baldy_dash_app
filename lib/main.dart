import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'engine.dart';

import 'service/service_registry.dart';
import 'ux/app.dart';

void main() async {
  final serviceRegistry = await ServiceRegistry.bootstrap();
  print('Loaded settings: ${serviceRegistry.settings.uuid}');
  Engine.initialize(ServiceRegistry.I.raceService);
  //print('Initialized Engine for player: ${Engine.I.player}');

  return runApp(
    ChangeNotifierProvider<ServiceRegistry>(
      create: (_) => ServiceRegistry.I,
      child: BaldyDashApp(),
    ),
  );
}
