import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'identity.dart';

part 'message.g.dart';

@JsonSerializable()
@immutable
class Message extends Identity {
  final String fromPlayerId;
  final DateTime timestamp;
  final String text;
  final String? toPlayerId;
  final String? photoUrl;

  const Message(super.id, super.path,
      {required this.fromPlayerId,
      required this.timestamp,
      required this.text,
      this.toPlayerId,
      this.photoUrl});

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, Object?> toJson() => _$MessageToJson(this);

  @override
  List<Object> get props => [
        'fromPlayerId',
        'timestamp',
        'text',
        'toPlayerId',
        'photoUrl',
      ];

  @override
  bool get stringify => true;
}
