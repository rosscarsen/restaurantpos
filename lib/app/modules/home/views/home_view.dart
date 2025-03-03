import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../../utils/progresshub.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        body: Container(
          color: const Color.fromARGB(255, 111, 69, 226),
          child: Padding(
            padding: EdgeInsets.only(top: context.mediaQuery.padding.top),
            child: Obx(
              () => ProgressHUD(
                inAsyncCall: controller.isloading.value,
                opacity: 0.7,
                child: WebViewWidget(controller: HomeController.to.webViewController),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
