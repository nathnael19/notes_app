import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Intro2 extends StatelessWidget {
  const Intro2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Smart & Simple Organization",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text("Categorize your notes and stay on top of your ideas"),
          SvgPicture.asset("assets/2.svg", height: 500),
        ],
      ),
    );
  }
}
