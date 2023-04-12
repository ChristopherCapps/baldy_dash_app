import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'waypoint.g.dart';

@JsonSerializable()
@immutable
class Waypoint extends Equatable {
  final int id;
  final String clue;
  final String answers;
  final String? imageUrl;

  const Waypoint(
      {required this.id,
      required this.clue,
      required this.answers,
      this.imageUrl});

  factory Waypoint.fromJson(Map<String, dynamic> json) =>
      _$WaypointFromJson(json);

  Map<String, Object?> toJson() => _$WaypointToJson(this);

  @override
  List<Object> get props => ['id', 'clue', 'answers', 'imageUrl'];

  @override
  bool get stringify => true;
}
