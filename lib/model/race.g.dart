// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'race.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Race _$RaceFromJson(Map<String, dynamic> json) => Race(
      id: json['id'] as String,
      name: json['name'] as String,
      logoUrl: json['logoUrl'] as String?,
    );

Map<String, dynamic> _$RaceToJson(Race instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'name': instance.name,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('logoUrl', instance.logoUrl);
  return val;
}
