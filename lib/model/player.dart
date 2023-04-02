class Player {
  final String uuid;
  final String? friendlyName;

  Player({required this.uuid, this.friendlyName});

  Player.fromJson(Map<String, Object?> json)
      : this(
          uuid: json['uuid']! as String,
          friendlyName: json['friendlyName'] as String,
        );

  Map<String, Object?> toJson() => {
        'uuid': uuid,
        'friendlyName': friendlyName,
      };
}
