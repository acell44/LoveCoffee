import 'package:flutter/material.dart';
import 'package:lovecoffee/page/onboarding2.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:lovecoffee/page/page1.dart';
import 'package:lovecoffee/page/page2.dart';
import 'package:lovecoffee/page/page3.dart';

class Onboarding extends StatefulWidget {
  @override
  _OnboardingState createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  void _nextPage() {
    if (_currentPage < 2) {
      _controller.nextPage(
          duration: Duration(milliseconds: 500), curve: Curves.easeInOut);
    }
  }

  // Fungsi buat ngubah halaman berdasarkan gesture slide
  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  // Fungsi buat lompat langsung ke halaman 3
  void _skipToPage3() {
    _controller.jumpToPage(2);
    setState(() {
      _currentPage = 2;
    });
  }

  void _startNow() {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: Duration(milliseconds: 500), // Durasi animasi
        pageBuilder: (context, animation, secondaryAnimation) =>
            Onboarding2(), // Halaman tujuan
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var begin = Offset(1.0, 0.0); // Posisi awal (kanan)
          var end = Offset.zero; // Posisi akhir (posisi default)
          var curve = Curves.easeInOut;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 500,
            child: PageView(
              controller: _controller,
              onPageChanged: _onPageChanged,
              children: [
                Page1(),
                Page2(),
                Page3(),
              ],
            ),
          ),
          SmoothPageIndicator(
            controller: _controller,
            count: 3,
            effect: ExpandingDotsEffect(
              dotColor: Colors.grey.shade300,
              activeDotColor: Color.fromARGB(255, 87, 34, 2),
              dotHeight: 10,
              dotWidth: 10,
            ),
          ),

          Container(
            margin: const EdgeInsets.only(top: 60.0),
            padding: const EdgeInsets.only(left: 20.0, right: 20.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: AnimatedContainer(
                    duration: Duration(seconds: 1),
                    curve: Curves.easeInOut,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        backgroundColor: Color.fromARGB(255, 87, 34, 2),
                        padding: const EdgeInsets.all(15.0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          _currentPage == 2 ? "Start Now" : "Continue",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      onPressed: () {
                        if (_currentPage == 2) {
                          _startNow();
                        } else {
                          _nextPage();
                        }
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          // Tombol Skip yang cuma muncul kalo bukan di halaman 3
          if (_currentPage < 2)
            Container(
              margin: const EdgeInsets.only(bottom: 50.0),
              padding: const EdgeInsets.only(left: 150, right: 150),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0)),
                        backgroundColor: Colors.white,
                        padding: const EdgeInsets.all(15.0),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            color: Color.fromARGB(255, 87, 34, 2),
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                      onPressed: _skipToPage3, // Langsung menuju halaman 3
                    ),
                  ),
                ],
              ),
            ),
          Spacer(),
        ],
      ),
    );
  }
}
