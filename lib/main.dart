import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'engine.dart';
import 'service/service_registry.dart'; // NEW
import 'ux/app.dart';

void main() async {
  await ServiceRegistry.bootstrap();
  print('Loaded settings: ${ServiceRegistry.I.settings.uuid}');

  initializeEngine();

  return runApp(
    ChangeNotifierProvider<ServiceRegistry>(
      // NEW
      create: (_) => ServiceRegistry.I, // NEW
      child: const BaldyDashApp(), // NEW
    ),
  );
}

void initializeEngine() {
  Engine.initialize(
    ServiceRegistry.I.settings,
    ServiceRegistry.I.raceService,
  );
}
