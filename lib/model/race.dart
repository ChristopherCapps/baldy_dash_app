import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'race.g.dart';

@JsonSerializable()
@immutable
class Race extends Equatable {
  final String id;
  final String name;
  final String? tagline;
  final String? logoUrl;
  final bool available;

  const Race(
      {required this.id,
      required this.name,
      this.tagline,
      this.logoUrl,
      this.available = false});

  factory Race.fromJson(Map<String, dynamic> json) => _$RaceFromJson(json);

  Map<String, Object?> toJson() => _$RaceToJson(this);

  @override
  List<Object?> get props => [name, tagline, logoUrl, available];

  @override
  bool get stringify => true;
}
