import 'model/player.dart';

class Engine {
  static Engine? _instance;

  static Engine initialize(final Player player) {
    _instance = Engine._(player);

    return _instance!;
  }

  final Player _player;

  Engine._(this._player);

  Player get player => _player;

  static Engine get I => _instance!;
}
