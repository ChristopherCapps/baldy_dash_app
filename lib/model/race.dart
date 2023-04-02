import 'session.dart';

class Race {
  final String name;
  final String logoUrl;

  final List<Session> sessions;

  Race(this.name, this.logoUrl, this.sessions);

  Race.initial(name, logoUrl) : this(name, logoUrl, []);
}
