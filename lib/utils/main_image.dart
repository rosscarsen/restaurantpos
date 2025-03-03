import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class MainImage extends StatefulWidget {
  const MainImage({super.key});

  @override
  State<MainImage> createState() => _MainImageState();
}

class _MainImageState extends State<MainImage>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController _animationController;

  toggleAnimation() {
    animation = Tween(begin: 0.0, end: 25.0).animate(_animationController);
    if (_animationController.isDismissed) {
      _animationController.forward().whenComplete(() => toggleAnimation());
    }
    if (_animationController.isCompleted) {
      _animationController.reverse().whenComplete(() => toggleAnimation());
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this)
      ..addListener(() => setState(() {}));
    toggleAnimation();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0, animation.value),
      // child: Image.asset(
      //   'images/animation.png',
      //   height: Get.height * 0.25,
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const AutoSizeText(
            "POS",
            style: TextStyle(
              color: Colors.white,
              fontSize: 60,
              letterSpacing: 3,
              fontWeight: FontWeight.w900,
            ),
            maxLines: 1,
          ),
          AutoSizeText(
            "restaurant_system".tr,
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                color: Color.fromARGB(255, 194, 247, 3),
                fontSize: 25,
              ),
            ),
            maxLines: 1,
          )
        ],
      ),
    );
  }
}
