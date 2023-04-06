import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'message.g.dart';

@JsonSerializable()
@immutable
class Message extends Equatable {
  final String authorId;
  final DateTime sentTime;
  final String text;
  final String? imageUrl;

  const Message(
      {required this.authorId,
      required this.sentTime,
      required this.text,
      this.imageUrl});

  factory Message.fromJson(Map<String, dynamic> json) =>
      _$MessageFromJson(json);

  Map<String, Object?> toJson() => _$MessageToJson(this);

  @override
  List<Object> get props => ['authorId', 'sentTime', 'text', 'imageUrl'];

  @override
  bool get stringify => true;
}
