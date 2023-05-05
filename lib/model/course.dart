import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

import 'identity.dart';

part 'course.g.dart';

@JsonSerializable()
@immutable
class Course extends Identity {
  final String name;

  const Course(super.id, super.path, {required this.name});

  factory Course.fromJson(Map<String, dynamic> json) => _$CourseFromJson(json);

  Map<String, Object?> toJson() => _$CourseToJson(this);

  @override
  List<Object?> get props => [name];

  @override
  bool get stringify => true;
}
