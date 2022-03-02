import 'dart:async';

import 'package:circular_reveal_animation/circular_reveal_animation.dart';
import 'package:crowd_application/screens/intro_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SlideRightRoute extends PageRouteBuilder {
  final Widget page;
  SlideRightRoute({required this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 1),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  double radius = 200;
  static const Color _color = Color.fromRGBO(169, 146, 254, 1);
  late AnimationController animationController;
  late Animation<double> animation;
  // launching next screen
  route() {
    Navigator.pushReplacement(
      context,
      PageTransition(
        duration: const Duration(seconds: 1),
        curve: Curves.easeOut,
        child: const IntroScreen(),
        type: PageTransitionType.topToBottom,
      ),
    );
  }

  startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, route);
  }

  @override
  void initState() {
    super.initState();
    startTime();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );
    animation = CurvedAnimation(
      parent: animationController,
      curve: Curves.elasticInOut,
    );
  }

  @override
  dispose() {
    animationController.dispose(); // you need this
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    animationController.forward();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CircularRevealAnimation(
        minRadius: 100,
        // maxRadius: double.maxFinite,
        animation: animation,
        child: Container(
          color: _color,
          child: Center(
            child: SizedBox(
              width: 160,
              child: FittedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'CROW',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'DIO',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
