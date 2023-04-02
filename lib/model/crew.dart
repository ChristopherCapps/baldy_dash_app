import 'player.dart';
import 'message.dart';

class Crew {
  final String name;
  final List<Player> players;
  final List<Message> transcript;

  Crew({required this.name, required this.players, required this.transcript});

  Crew.initialWithPlayers({required name, required players})
      : this(name: name, players: players, transcript: []);

  Crew.initial({required name})
      : this.initialWithPlayers(name: name, players: []);
}
