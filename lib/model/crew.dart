import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'identity.dart';

part 'crew.g.dart';

@JsonSerializable()
@immutable
class Crew extends Identity {
  final String name;
  final String courseId;
  final String waypointId;
  final Set<String> players;
  final DateTime? completedTime;

  Crew._(
    super.id,
    super.path, {
    required this.name,
    required this.courseId,
    required this.waypointId,
    required Set<String> players,
    this.completedTime,
  }) : players = Set.unmodifiable(players);

  factory Crew(
    final String id,
    final String path, {
    required final String name,
    required final String courseId,
    required final String waypointId,
    required final Set<String> players,
    DateTime? completedTime,
  }) = _Crew;

  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);

  static Map<String, Object?> toJson(final Crew crew) => _$CrewToJson(crew);

  @override
  List<Object?> get props =>
      [name, courseId, waypointId, players, completedTime];

  @override
  bool get stringify => true;
}

class _Crew extends Crew {
  _Crew(
    super.id,
    super.path, {
    required super.name,
    required super.courseId,
    required super.waypointId,
    required super.players,
    super.completedTime,
  }) : super._();
}
