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

  Crew copyWith(
          {String? name,
          String? courseId,
          String? waypointId,
          Set<String>? players,
          DateTime? completedTime}) =>
      _Crew.copy(
          from: this,
          name: name,
          courseId: courseId,
          waypointId: waypointId,
          players: players);
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

  static Crew copy(
          {required Crew from,
          String? name,
          String? courseId,
          String? waypointId,
          Set<String>? players,
          dynamic completedTime = _Unset}) =>
      _Crew(from.id, from.path,
          name: name ?? from.name,
          courseId: courseId ?? from.courseId,
          waypointId: waypointId ?? from.waypointId,
          players: players ?? from.players,
          completedTime: completedTime == _Unset
              ? from.completedTime
              : completedTime as DateTime?);

  @override
  Crew copyWith(
          {String? name,
          String? courseId,
          String? waypointId,
          Set<String>? players,
          DateTime? completedTime}) =>
      _Crew.copy(
          from: this,
          name: name,
          courseId: courseId,
          waypointId: waypointId,
          players: players);
}

class _Unset {}

typedef DecomposedCrewPath = ({String raceId, String sessionId, String crewId});
