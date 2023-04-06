// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Session _$SessionFromJson(Map<String, dynamic> json) => Session(
      id: json['id'] as String,
      name: json['name'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
    );

Map<String, dynamic> _$SessionToJson(Session instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'startTime': instance.startTime.toIso8601String(),
    };
