import 'package:flutter/material.dart';
import 'package:notes_app/pages/homePage.dart';
import 'package:notes_app/pages/into_pages/intro_page1.dart';
import 'package:notes_app/pages/into_pages/intro_page2.dart';
import 'package:notes_app/pages/into_pages/intro_page3.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({super.key});

  @override
  State<IntroPage> createState() => _IntroPageState();
}

PageController controller = PageController();
bool isLastPage = false;

class _IntroPageState extends State<IntroPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            onPageChanged: (value) {
              setState(() {
                isLastPage = (value == 2);
              });
            },
            controller: controller,
            children: [Intro1(), Intro2(), Intro3()],
          ),
          Container(
            alignment: Alignment(0, 0.9),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () {
                    controller.jumpToPage(2);
                  },
                  child: Text("Skip"),
                ),
                SmoothPageIndicator(controller: controller, count: 3),
                isLastPage
                    ? InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomePage()),
                        );
                      },
                      child: Text("Get Started"),
                    )
                    : InkWell(
                      onTap: () {
                        controller.nextPage(
                          duration: Duration(milliseconds: 400),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: Text("Next"),
                    ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
