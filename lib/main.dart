import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'service/service_registry.dart'; // NEW
import 'ux/app.dart';

void main() async {
  final serviceRegistry = await ServiceRegistry.bootstrap();
  print('Loaded settings: ${serviceRegistry.settings.uuid}');

  return runApp(
    ChangeNotifierProvider<ServiceRegistry>(
      // NEW
      create: (_) => ServiceRegistry.I, // NEW
      child: const BaldyDashApp(), // NEW
    ),
  );
}
