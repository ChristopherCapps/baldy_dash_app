import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'service/service_registry.dart';
import 'ux/page/races_page.dart';

class BaldyDashApp extends StatelessWidget {
  const BaldyDashApp({super.key});

  @override
  Widget build(BuildContext context) {
    // This app is designed only to work vertically, so we limit
    // orientations to portrait up and down.
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return MaterialApp(
      home: RacesPage(raceService: ServiceRegistry.I.raceService),
    );
  }
}
