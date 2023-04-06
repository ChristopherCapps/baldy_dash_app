import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'session.g.dart';

@JsonSerializable()
@immutable
class Session extends Equatable {
  final String id;
  final String name;
  final DateTime startTime;

  const Session(
      {required this.id, required this.name, required this.startTime});

  factory Session.fromJson(Map<String, dynamic> json) =>
      _$SessionFromJson(json);

  Map<String, Object?> toJson() => _$SessionToJson(this);

  @override
  List<Object> get props => ['name', 'startTime'];

  @override
  bool get stringify => true;
}
