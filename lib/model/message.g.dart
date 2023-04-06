// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Message _$MessageFromJson(Map<String, dynamic> json) => Message(
      authorId: json['authorId'] as String,
      sentTime: DateTime.parse(json['sentTime'] as String),
      text: json['text'] as String,
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$MessageToJson(Message instance) {
  final val = <String, dynamic>{
    'authorId': instance.authorId,
    'sentTime': instance.sentTime.toIso8601String(),
    'text': instance.text,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('imageUrl', instance.imageUrl);
  return val;
}
