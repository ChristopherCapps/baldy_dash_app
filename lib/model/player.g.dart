// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Player _$PlayerFromJson(Map<String, dynamic> json) => Player(
      id: json['id'] as String,
      role: $enumDecode(_$RoleEnumMap, json['role']),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$PlayerToJson(Player instance) {
  final val = <String, dynamic>{
    'id': instance.id,
    'role': _$RoleEnumMap[instance.role]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('name', instance.name);
  return val;
}

const _$RoleEnumMap = {
  Role.admin: 'admin',
  Role.user: 'user',
};
