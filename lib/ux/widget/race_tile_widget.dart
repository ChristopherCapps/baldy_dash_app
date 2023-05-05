import 'package:flutter/material.dart';

import '../../model/race.dart';

class RaceTileWidget extends StatelessWidget {
  final Race race;
  final GestureTapCallback? onTap;

  const RaceTileWidget(this.race, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    print('Render race: $race');
    return ListTile(
      enabled: race.available,
      onTap: onTap,
      title: Text(race.name),
      subtitle: Text(race.tagLineOrDefault),
      leading: raceLogo(race),
      trailing: race.available
          ? const Icon(
              Icons.verified,
              color: Colors.green,
            )
          : null,
    );
  }

  static const defaultRaceUrl =
      'https://quest-baldy-dash.web.app/images/Old-Baldy-p-500.jpg';

  CircleAvatar raceLogo(final Race race) => CircleAvatar(
        backgroundImage: NetworkImage(race.logoUrl ?? defaultRaceUrl),
        //foregroundImage: NetworkImage(race.logoUrl ?? defaultRaceUrl),
        //child: const Text('BD'),
      );
}
