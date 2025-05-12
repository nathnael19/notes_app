import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Intro3 extends StatelessWidget {
  const Intro3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Works Offline",
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          Text("Take notes without internet. Sync later when online"),
          SvgPicture.asset("assets/2.svg", height: 500),
        ],
      ),
    );
  }
}
