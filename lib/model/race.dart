import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'identity.dart';

part 'race.g.dart';

@JsonSerializable()
@immutable
class Race extends Identity {
  final String name;
  final String? tagLine;
  final String? logoUrl;
  final bool available;

  const Race(super.id, super.path,
      {required this.name, this.tagLine, this.logoUrl, this.available = false});

  String get tagLineOrDefault => tagLine ?? 'The adventure awaits!';

  factory Race.fromJson(Map<String, dynamic> json) => _$RaceFromJson(json);

  Map<String, Object?> toJson() => _$RaceToJson(this);

  @override
  List<Object?> get props => [name, tagLine, logoUrl, available];

  @override
  bool get stringify => true;
}
