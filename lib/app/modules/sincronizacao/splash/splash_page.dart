import 'package:crm_app/app/modules/sincronizacao/splash/splash_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final _controller = Modular.get<SplashController>();
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    _controller.load();

    _fadeInLogo();
  }

  void _fadeInLogo() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if(mounted) {
        setState(() {
          _opacity = 1.0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.5),
      body: Center(
        child: AnimatedOpacity(
          opacity: _opacity,
          duration: const Duration(milliseconds: 1500),
          child: Image.asset('assets/images/app_icon_grande.png'),
        ),
      ),
    );
  }
}