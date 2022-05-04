import 'package:crowd_application/screens/auth/signup_screen.dart';
import 'package:crowd_application/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    final List<PageViewModel> _pages = [
      PageViewModel(
        title: "What is Crowdfunding?",
        bodyWidget: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Crowdfunding is the practice of funding a project or venture by raising money from a large number of people, in modern times typically via the Internet.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        image: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0),
          child: Image.asset('assets/images/intro-img1.png'),
        ),
      ),
      PageViewModel(
        title: "Title of second page",
        bodyWidget: const Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              'Crowdfunding is the practice of funding a project or venture by raising money from a large number of people, in modern times typically via the Internet.',
              textAlign: TextAlign.center,
            ),
          ),
        ),
        image: Image.asset('assets/images/intro-img2.png'),
      ),
      PageViewModel(
        title: "Title of third page",
        bodyWidget: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Crowdfunding is the practice of funding a project or venture by raising money from a large number of people, in modern times typically via the Internet.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Colors.black,
                  ),
                  child: const Text('Sign up!'),
                )
              ],
            ),
          ),
        ),
        image: Image.asset(
          'assets/images/intro-img3.png',
        ),
      ),
    ];
    return Scaffold(
      body: SafeArea(
        child: IntroductionScreen(
          pages: _pages,
          done: const Text("Skip!",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
              )),
          onDone: () {
            // When done button is press
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false);
          },
          onSkip: () {
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                  builder: (context) => const HomeScreen(),
                ),
                (route) => false);
          },
          showNextButton: true,
          showBackButton: false,
          showSkipButton: true,
          next: const Text(
            "Next",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
          skip: const Text(
            "Skip",
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }
}
