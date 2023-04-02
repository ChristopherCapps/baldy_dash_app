import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'service/service_registry.dart';                 // NEW

void main() async {
  await ServiceRegistry.bootstrap();
  print('Loaded settings: ${ServiceRegistry.I.settings.uuid}');

  return runApp(
    ChangeNotifierProvider<ServiceRegistry>(            // NEW
      create: (_) => ServiceRegistry.I, // NEW
      child: const BaldyDashApp(),               // NEW
    ),
  );
}