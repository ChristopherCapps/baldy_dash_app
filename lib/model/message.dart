import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'message.g.dart';

@JsonSerializable()
@immutable
class Message extends Equatable {
  final String senderName;
  final DateTime timestamp;
  final String text;
  final String? photoUrl;
  final String? toPlayerId;

  const Message(
    this.senderName,
    this.timestamp,
    this.text, {
    this.photoUrl,
    this.toPlayerId,
  });

  Message.now(final String senderName, final String text,
      {final String? photoUrl, final String? toPlayerId})
      : this(
          senderName,
          DateTime.now(),
          text,
          photoUrl: photoUrl,
          toPlayerId: toPlayerId,
        );

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  static Map<String, Object?> toJson(final Message message) =>
      _$MessageToJson(message);

  @override
  List<Object> get props => [
        'senderName',
        'timestamp',
        'text',
        'photoUrl',
        'toPlayerId',
      ];

  @override
  bool get stringify => true;
}
