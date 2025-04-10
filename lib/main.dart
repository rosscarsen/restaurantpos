import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';
import 'config.dart';
import 'languages/measages.dart';

Future<bool> checkCheckData() async {
  final box = GetStorage();
  String? company = box.read("company");
  String? url = box.read("loadingUrl");
  String? cashier = box.read("cashier");
  String? user = box.read("user");
  String? pwd = box.read("pwd");
  bool isValid =
      (url?.isNotEmpty ?? false) &&
      (cashier?.isNotEmpty ?? false) &&
      (user?.isNotEmpty ?? false) &&
      (pwd?.isNotEmpty ?? false) &&
      (company?.isNotEmpty ?? false);

  if (isValid) {
    //非登录先检测数据，如何能连接数据库，跳去登录页，不能连接回到登录页
    try {
      Map<String, dynamic> checkData = {"company": company, 'cashier': cashier, 'pwd': pwd, 'user': user, 'url': url};

      Dio dio = Dio();
      dio.options.baseUrl = Config.baseurl;
      dio.options.contentType = "application/json; charset=utf-8";
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.responseType = ResponseType.plain;
      dio.options.headers = {HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"};

      var response = await dio.post(Config.checkCacheData, data: checkData);

      if (response.statusCode == 200) {
        Map<String, dynamic> ret = jsonDecode(response.data);
        if (ret["status"].toString() == "1") {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  } else {
    return false;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  /*  SystemChrome.setPreferredOrientations(¡
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]); */
  if (Platform.isAndroid) {
    //设置状态栏与Appbar同一色
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color.fromARGB(255, 141, 63, 155),
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  await GetStorage.init();
  final GetStorage box = GetStorage();
  String localLangString = box.read("localLang") ?? "";
  Locale locale =
      localLangString.isNotEmpty
          ? localLangString == "zh_CN"
              ? const Locale("zh", "CN")
              : localLangString == "zh_HK"
              ? const Locale("zh", "HK")
              : const Locale("en", "us")
          : const Locale("zh", "HK");

  bool checkStatus = await checkCheckData();
  String initialRoute = checkStatus ? Routes.HOME : Routes.SIGNIN;
  runApp(
    GetMaterialApp(
      title: "POS",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      builder: (context, child) {
        //加载框
        final easyLoading = EasyLoading.init();
        child = easyLoading(context, child);

        //设置文字大小不随系统设置改变
        child = MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: const TextScaler.linear(1.0)),
          child: child,
        );
        return child;
      },
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          elevation: 0,
          backgroundColor: const Color.fromARGB(255, 251, 251, 251),
          foregroundColor: Colors.grey[900]!,
        ),
      ),
      locale: locale,
      supportedLocales: const [
        Locale('zh', 'CN'),
        Locale('zh', 'HK'),
        Locale('en', 'US'),
      ],
      fallbackLocale: const Locale("en", "us"),
      translations: Messages(),
    ),
  );
}
