import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BackgroundWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: SvgPicture.asset(
        "assets/SvgNavbar/background.svg", // تأكد من المسار الصحيح
        // ملء الشاشة
      ),
    );
  }
}

class BackgroundWidget2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: [
          Positioned(
              top: 0, left: 0, child: SvgPicture.asset("assets/top_shap.svg")),
          Positioned(
              top: 247,
              right: 0,
              child: Container(
                child: SvgPicture.asset("assets/center_shap.svg"),
              )),
          Positioned(
              top: 382,
              left: 33,
              child: Container(
                child: SvgPicture.asset("assets/3right.svg"),
              )),
          Positioned(
              top: 382,
              right: 0,
              child: Opacity(
                opacity: 0.3,
                child: Container(
                  child: SvgPicture.asset(
                    "assets/4center.svg",
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
