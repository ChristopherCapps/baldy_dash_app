import 'crew.dart';

class Session {
  final String name;
  final DateTime startTime;
  final List<Crew> crews;

  Session({required this.name, required this.startTime, required this.crews});

  Session.initial(name, startTime)
      : this(
          name: name,
          startTime: startTime,
          crews: [],
        );

  Session.fromJson(Map<String, Object?> json)
      : this.initial(
          json['name']! as String,
          json['startTime'] as DateTime,
        );
}
