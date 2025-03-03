import 'package:flutter/material.dart';
import 'package:get/get.dart';

///背景颜色
BoxDecoration get boxLinear {
  return const BoxDecoration(
    gradient: LinearGradient(
      colors: [
        Color.fromARGB(255, 56, 106, 241),
        Color.fromARGB(255, 141, 63, 155),
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      //stops: [0.2, .4, .95],
    ),
  );
}

SnackbarController successSnackbar(String messages,
    {String? title, int showTime = 3}) {
  return Get.snackbar(
    "",
    "",
    titleText: Text(
      title ?? "systemMessages".tr,
      style: const TextStyle(
          color: Colors.green, fontSize: 16.0, fontWeight: FontWeight.bold),
    ),
    messageText: Text(messages,
        style: const TextStyle(color: Colors.green, fontSize: 14.0)),
    icon: const Icon(
      Icons.check_circle,
      color: Colors.green,
      size: 30.0,
    ),
    backgroundColor: const Color.fromARGB(136, 5, 2, 2),
    duration: Duration(seconds: showTime),
  );
}
