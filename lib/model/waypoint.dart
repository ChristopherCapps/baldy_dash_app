import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'identity.dart';

part 'waypoint.g.dart';

@JsonSerializable()
@immutable
class Waypoint extends Identity {
  final String clue;
  final List<String> answers;
  final String? region;
  final String? imageUrl;

  const Waypoint(super.id, super.path,
      {required this.clue, required this.answers, this.region, this.imageUrl});

  factory Waypoint.fromJson(Map<String, dynamic> json) =>
      _$WaypointFromJson(json);

  Map<String, Object?> toJson() => _$WaypointToJson(this);

  @override
  List<Object?> get props => [id, path, clue, answers, region, imageUrl];

  @override
  bool get stringify => true;
}
