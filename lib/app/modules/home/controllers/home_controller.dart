import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../routes/app_pages.dart';

class HomeController extends GetxController {
  static HomeController get to => Get.find();
  RxBool isloading = true.obs;
  late WebViewController webViewController;
  late final WebViewCookieManager cookieManager = WebViewCookieManager();
  final box = GetStorage();
  String loadUrl = "";
  @override
  void onInit() {
    initUrl();
    initWebview();
    super.onInit();
  }

  initUrl() {
    String? url = box.read("loadingUrl");
    String? cashier = box.read("cashier");
    String? user = box.read("user");
    String? pwd = box.read("pwd");
    bool isValid =
        (url?.isNotEmpty ?? false) &&
        (cashier?.isNotEmpty ?? false) &&
        (user?.isNotEmpty ?? false) &&
        (pwd?.isNotEmpty ?? false);

    if (isValid) {
      final GetStorage box = GetStorage();
      String localLangString = box.read("localLang") ?? "";
      var lang =
          localLangString.isNotEmpty
              ? localLangString == "zh_CN"
                  ? "zh-cn"
                  : localLangString == "zh_HK"
                  ? 'zh-tw'
                  : localLangString == "en_us"
                  ? 'en-us'
                  : 'zh-tw'
              : Get.locale.toString() == "zh_CN"
              ? "zh-cn"
              : Get.locale.toString() == "zh_HK"
              ? 'zh-tw'
              : Get.locale.toString() == "en_us"
              ? 'en-us'
              : 'zh-tw';
      loadUrl = "${ensureHttps(url!)}/?l=$lang&cashier=$cashier&user=$user&pwd=$pwd";
    } else {
      loadUrl = "";
    }
  }

  /// 确保URL以https开头
  String ensureHttps(String url) {
    final uri = Uri.parse(url);
    final updatedUri = uri.scheme == 'http' ? uri.replace(scheme: 'https') : uri;
    return updatedUri.toString();
  }

  void initWebview() {
    if (loadUrl.isNotEmpty) {
      webViewController =
          WebViewController()
            ..setJavaScriptMode(JavaScriptMode.unrestricted)
            ..setUserAgent("flutter")
            ..setBackgroundColor(const Color(0x00000000))
            ..setNavigationDelegate(
              NavigationDelegate(
                onProgress: (int progress) {},
                onPageStarted: (String url) {
                  isloading.value = true;
                },
                onPageFinished: (String url) {
                  isloading.value = false;

                  webViewController.runJavaScriptReturningResult('typeof flutterCallJs === "function"').then((value) {
                    bool? result = value as bool;
                    if (result == true) {
                      webViewController.runJavaScript("flutterCallJs('flutter调用JS')");
                    }
                  });
                },
                onWebResourceError: (WebResourceError error) {
                  isloading.value = false;
                  // showCupertinoDialog(
                  //     context: Get.context!,
                  //     builder: (context) {
                  //       return CupertinoAlertDialog(
                  //         title: Text('systemMessages'.tr),
                  //         content: Text('loading error'.tr),
                  //         actions: <Widget>[
                  //           CupertinoDialogAction(
                  //             child: Text('close'.tr),
                  //             onPressed: () {
                  //               Get.back();
                  //               final GetStorage box = GetStorage();
                  //               box.remove("loadingUrl");
                  //               Get.toNamed(Routes.SIGNIN);
                  //             },
                  //           ),
                  //         ],
                  //       );
                  //     });
                },
                onNavigationRequest: (NavigationRequest request) {
                  return NavigationDecision.navigate;
                },
              ),
            )
            ..getScrollPosition().then((value) {
              debugPrint("滚动位置: ${value.dx}//${value.dy}");
            })
            ..setOnConsoleMessage((message) {
              debugPrint("控制台消息: ${message.message}");
            })
            ..addJavaScriptChannel(
              "FLUTTER_CHANNEL",
              onMessageReceived: (JavaScriptMessage message) {
                showCupertinoDialog(
                  context: Get.context!,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title: Text('systemMessages'.tr),
                      content: Text('confirmLoginOut'.tr),
                      actions: <Widget>[
                        CupertinoDialogAction(
                          child: Text('cancel'.tr),
                          onPressed: () {
                            Get.back();
                          },
                        ),
                        CupertinoDialogAction(
                          child: Text('confirm'.tr),
                          onPressed: () {
                            //controller.cookieManager.clearCookies();
                            final GetStorage box = GetStorage();
                            box.remove("loadingUrl");
                            Get.toNamed(Routes.SIGNIN);
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            )
            ..addJavaScriptChannel(
              "setLang",
              onMessageReceived: (JavaScriptMessage message) {
                String localLangString = message.message.toString();

                Locale locale =
                    localLangString.isNotEmpty
                        ? localLangString == "zh-cn"
                            ? const Locale("zh", "CN")
                            : localLangString == "zh-tw"
                            ? const Locale("zh", "HK")
                            : const Locale("en", "us")
                        : const Locale("zh", "HK");
                final GetStorage box = GetStorage();
                box.remove("localLang");
                box.write("localLang", locale.toString());
                Get.updateLocale(locale);
              },
            )
            ..loadRequest(Uri.parse(loadUrl));
    } else {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Get.offAllNamed(Routes.SIGNIN);
      });
    }
  }

  // void setProgress(double currentProgress) {
  //   progress.value = currentProgress;
  // }
}
