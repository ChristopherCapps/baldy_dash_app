import 'package:flutter/foundation.dart' as foundation;

import '../firebase_options.dart';
import 'firestore_race_service.dart';
import 'firestore_service.dart';
import 'player_service.dart';
import 'race_service.dart';
import 'settings.dart';

class ServiceRegistry extends foundation.ChangeNotifier {
  static ServiceRegistry? _instance;

  final Settings _settings;
  final FirestoreService _firestoreService;
  final RaceService _raceService;

  ServiceRegistry._(this._settings, this._firestoreService, this._raceService) {
    _instance = this;
  }

  Settings get settings => _settings;

  FirestoreService get firestoreService => _firestoreService;
  RaceService get raceService => _raceService;

  PlayerService get playerService => PlayerService.of(_raceService);

  static Future<ServiceRegistry> bootstrap() async {
    if (ServiceRegistry._instance != null) {
      throw Exception('Already bootstrapped');
    }
    return Settings.create().then(
      (settingsF) => FirestoreService.init(
        DefaultFirebaseOptions.currentPlatform,
      ).then(
        (firestoreService) => FirestoreRaceService.init(
          firestoreService.database,
          settingsF.uuid,
        ).then(
          (firestoreRaceService) => ServiceRegistry._(
            settingsF,
            firestoreService,
            firestoreRaceService,
          ),
        ),
      ),
    );
  }

  static ServiceRegistry get I => ServiceRegistry._instance!;
}
