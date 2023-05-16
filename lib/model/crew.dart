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

  const Crew(super.id, super.path,
      {required this.name,
      required this.courseId,
      required this.waypointId,
      required this.players,
      this.completedTime});

  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);

  static Map<String, Object?> toJson(final Crew crew) => _$CrewToJson(crew);

  @override
  List<Object?> get props =>
      [name, courseId, waypointId, players, completedTime];

  @override
  bool get stringify => true;
}
