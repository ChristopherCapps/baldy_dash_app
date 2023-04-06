import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'crew.g.dart';

@JsonSerializable()
@immutable
class Crew extends Equatable {
  final String id;
  final String name;

  const Crew({required this.id, required this.name});

  factory Crew.fromJson(Map<String, dynamic> json) => _$CrewFromJson(json);

  Map<String, Object?> toJson() => _$CrewToJson(this);

  @override
  List<Object> get props => ['name'];

  @override
  bool get stringify => true;
}
