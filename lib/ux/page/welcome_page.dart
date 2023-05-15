import 'package:flutter/material.dart';

import '../../engine.dart';

import '../widget/welcome_back_widget.dart';
import '../widget/welcome_newcomer_widget.dart';

class WelcomePage extends StatelessWidget {
  final Engine _engine;

  WelcomePage({Key? key}) : this.custom(Engine.I, key: key);

  const WelcomePage.custom(this._engine, {super.key});

  @override
  Widget build(BuildContext context) => _engine.playerNameIsUnset()
      ? WelcomeNewcomerWidget()
      : WelcomeBackWidget();
}
