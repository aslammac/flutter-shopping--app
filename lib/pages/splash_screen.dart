import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          height: 65,
          width: 65,
          child: FlareActor(
            'assets/flare/loading.flr',
            alignment: Alignment.center,
            // fit: BoxFit.scaleDown,
            animation: 'active',
          ),
        ),
      ),
    );
  }
}
