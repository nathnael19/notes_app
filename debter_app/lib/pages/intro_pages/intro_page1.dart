import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Intro1 extends StatelessWidget {
  const Intro1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Welcome to Debter",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text("Create your toghouts anywhere anytime"),
          SvgPicture.asset("assets/1.svg", fit: BoxFit.fitHeight),
        ],
      ),
    );
  }
}
