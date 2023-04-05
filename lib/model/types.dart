class Message {
  final String authorUuid;
  final String text;
  final String? imageUrl;

  Message({required this.authorUuid, required this.text, this.imageUrl});

  Message.fromJson(Map<String, Object?> json)
      : this(
    authorUuid: json['authorUuid']! as String,
    text: json['text']! as String,
    imageUrl: json['imageUrl'] as String,
  );

  Map<String, Object?> toJson() => {
    'authorUuid': authorUuid,
    'text': text,
    'imageUrl': imageUrl,
  };
}

class Player {
  final String uuid;
  final String? name;

  Player({required this.uuid, this.name});

  Player.fromJson(Map<String, Object?> json)
      : this(
    uuid: json['uuid']! as String,
    name: json['name'] as String,
  );

  Map<String, Object?> toJson() => {
    'uuid': uuid,
    'name': name,
  };
}

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

class Session {
  final String name;
  final DateTime startTime;
  final List<Crew> crews;

  Session({required this.name, required this.startTime, required this.crews});

  Session.initial(name, startTime)
      : this(
    name: name,
    startTime: startTime,
    crews: [],
  );

  Session.fromJson(Map<String, Object?> json)
      : this.initial(
    json['name']! as String,
    json['startTime'] as DateTime,
  );
}

class Race {
  final String name;
  final String logoUrl;

  final List<Session> sessions;

  Race({required this.name, required this.logoUrl, required this.sessions});

  Race.initial({ required name, required logoUrl})
      : this(
      name: name,
      logoUrl: logoUrl,
      sessions: []);

  Race.fromJson(Map<String, Object?> json)
  : this.initial(
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String);
}
