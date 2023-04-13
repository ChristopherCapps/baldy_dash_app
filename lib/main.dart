import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'engine.dart';
import 'service/service_registry.dart'; // NEW
import 'ux/app.dart';

void main() async {
  final serviceRegistry = await ServiceRegistry.bootstrap();
  print('Loaded settings: ${serviceRegistry.settings.uuid}');

  final engine = await initializeEngine();
  print('Initialized engine with player ${engine.player}');

  return runApp(
    ChangeNotifierProvider<ServiceRegistry>(
      // NEW
      create: (_) => ServiceRegistry.I, // NEW
      child: const BaldyDashApp(), // NEW
    ),
  );
}

Future<Engine> initializeEngine() async => await Engine.initialize(
      ServiceRegistry.I.settings,
      ServiceRegistry.I.raceService,
    );
