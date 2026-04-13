import 'package:crm_app/app/shared/theme/light/theme_light.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AppWidget extends StatelessWidget{
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'teste1 app_widget',
      theme: ThemeLight.themeData,
      routerConfig: Modular.routerConfig,
    );
  }
}