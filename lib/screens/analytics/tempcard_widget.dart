import 'package:flutter/material.dart';

class TempCard extends StatelessWidget {
  const TempCard(
      {Key? key, required this.label, required this.text, required this.icon})
      : super(key: key);
  final String label;
  final String text;
  final Icon icon;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        boxShadow: const [
          BoxShadow(
              color: Colors.black26, offset: Offset(0, 1), blurRadius: 1.0)
        ],
        color: const Color.fromARGB(255, 255, 252, 252),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width * 0.4,
            height: MediaQuery.of(context).size.width * 0.4,
            padding: const EdgeInsets.only(bottom: 15),
            child: Center(
              child: Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.3,
                ),
                child: FittedBox(
                  child: Text(
                    text,
                    textScaleFactor: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(top: 8, right: 10, child: icon),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Text(
                label,
                textScaleFactor: 0.8,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w300,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
