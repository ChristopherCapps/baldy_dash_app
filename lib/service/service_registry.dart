import 'package:baldy_dash_app/firebase_options.dart';
import 'package:baldy_dash_app/service/firestore_service.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'settings.dart';

class ServiceRegistry extends foundation.ChangeNotifier {
  static ServiceRegistry? _instance;

  final Settings _settings;
  final FirestoreService _firestoreService;

  ServiceRegistry._(this._settings, this._firestoreService) {
    _instance = this;
  }

  Settings get settings => _settings;
  FirestoreService get firestoreService => _firestoreService;

  static Future<ServiceRegistry> bootstrap() async {
    if (ServiceRegistry._instance != null) {
      throw Exception("Already bootstrapped");
    }
    return Settings.create().then(
            (settingsF) =>
                FirestoreService.init(DefaultFirebaseOptions.currentPlatform).then(
            (firestoreService) =>
                ServiceRegistry._(settingsF, firestoreService)));
  }

  static ServiceRegistry get I => ServiceRegistry._instance!;
}
