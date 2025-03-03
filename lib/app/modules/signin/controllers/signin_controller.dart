import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:pinput/pinput.dart';
import 'package:timer_count_down/timer_controller.dart';

import '../../../../config.dart';
import '../../../../utils/easy_toast.dart';
import '../../../../utils/style.dart';
import '../../../model/login_model.dart';
import '../../../routes/app_pages.dart';

class SigninController extends GetxController {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _verifyController = TextEditingController();
  final TextEditingController _cashierController = TextEditingController();
  final box = GetStorage();
  RxBool isChecked = true.obs;
  TextEditingController get companyController => _companyController;
  TextEditingController get emailController => _emailController;
  TextEditingController get pwdController => _pwdController;
  TextEditingController get verifyController => _verifyController;
  TextEditingController get userController => _userController;
  TextEditingController get cashierController => _cashierController;
  //倒计时
  final CountdownController _countdownController = CountdownController(autoStart: true);
  CountdownController get countdownController => _countdownController;
  bool startCount = false;
  RxBool isShowPassword = true.obs;
  final focusNode = FocusNode();
  @override
  void onInit() {
    _companyController.text = box.read("company") ?? '';
    _cashierController.text = box.read("cashier") ?? '';
    _userController.text = box.read("user") ?? '';
    _pwdController.text = box.read("pwd") ?? '';
    isChecked.value = box.read("ischecked") ?? true;
    super.onInit();
  }

  @override
  void onClose() {}
  void changeCheck(bool newVal) {
    isChecked.value = newVal;
    update(["check"]);
  }

  ///登录
  void login() async {
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);
    const fillColor = Color.fromRGBO(243, 246, 249, 0);
    const borderColor = Color.fromRGBO(23, 171, 144, 0.4);

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 22, color: Color.fromRGBO(30, 60, 87, 1)),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(19), border: Border.all(color: borderColor)),
    );

    showLoding('logging'.tr);
    Map<String, dynamic> loginData = {
      "company": _companyController.text,
      'cashier': _cashierController.text,
      'pwd': _pwdController.text,
      'user': _userController.text,
    };

    try {
      Dio dio = Dio();
      dio.options.baseUrl = Config.baseurl;
      dio.options.contentType = "application/json; charset=utf-8";
      dio.options.connectTimeout = const Duration(seconds: 10);
      dio.options.responseType = ResponseType.plain;
      dio.options.headers = {HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"};

      var response = await dio.post(Config.login, data: loginData);

      if (response.statusCode == 200) {
        LoginModel ret = LoginModel.fromJson(jsonDecode(response.data));
        if (ret.status == 200) {
          if (EasyLoading.isShow) {
            EasyLoading.dismiss();
          }
          if (ret.twoVerify == false) {
            final url = ret.data!.webSit;
            if (url != null) {
              box.write("loadingUrl", url);
              if (isChecked.value) {
                box.write("company", _companyController.text);
                box.write("cashier", _cashierController.text);
                box.write("user", _userController.text);
                box.write("pwd", _pwdController.text);
              }
              successLoding('loginSucceed'.tr);
              Get.offAllNamed(Routes.HOME);
            } else {
              errorLoding('websiteNotExist'.tr);
            }
          } else {
            successSnackbar("checkEmail".tr, showTime: 5);
            showCupertinoDialog(
              context: Get.context!,
              builder: (context) {
                return CupertinoAlertDialog(
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(children: [Text('enterVerify'.tr)]),
                  ),
                  content: Pinput(
                    length: 4,
                    controller: _verifyController,
                    focusNode: focusNode,
                    defaultPinTheme: defaultPinTheme,
                    hapticFeedbackType: HapticFeedbackType.lightImpact,
                    onCompleted: (pin) {
                      // debugPrint('onCompleted: $pin');
                    },
                    onChanged: (value) {
                      //debugPrint('onChanged: $value');
                    },
                    cursor: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 9),
                          width: 22,
                          height: 1,
                          color: focusedBorderColor,
                        ),
                      ],
                    ),
                    focusedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    submittedPinTheme: defaultPinTheme.copyWith(
                      decoration: defaultPinTheme.decoration!.copyWith(
                        color: fillColor,
                        borderRadius: BorderRadius.circular(19),
                        border: Border.all(color: focusedBorderColor),
                      ),
                    ),
                    errorPinTheme: defaultPinTheme.copyBorderWith(border: Border.all(color: Colors.redAccent)),
                  ),
                  actions: <Widget>[
                    CupertinoDialogAction(
                      child: Text('close'.tr),
                      onPressed: () {
                        Get.back();
                        _verifyController.text = "";
                      },
                    ),
                    CupertinoDialogAction(
                      child: Text('verify'.tr),
                      onPressed: () {
                        verifyOtp(verifyCode: _verifyController.text, data: ret);

                        //Get.toNamed(Routes.SIGNIN);
                      },
                    ),
                  ],
                );
              },
            );
          }
        } else if (ret.status == 0) {
          errorLoding('companyError'.tr);
        } else if (ret.status == 1) {
          errorLoding('cashierError'.tr);
        } else if (ret.status == 2) {
          errorLoding('Wrong_user_or_password'.tr);
        } else if (ret.status == 3) {
          errorLoding('authenticationDeliveryFailed'.tr);
        } else if (ret.status == 4) {
          errorLoding('websiteNotExist'.tr);
        }
      }
    } on DioException {
      errorLoding('requestException'.tr);
    }
  }

  ///改变倒计时状态
  // void changeStartCount(bool newVal) {
  //   if (_companyController.text == "") {
  //     errorLoding('companyEmpty'.tr);
  //   } else if (_emailController.text == "") {
  //     errorLoding('emailEmpty'.tr);
  //   } else if (!GetUtils.isEmail(_emailController.text)) {
  //     errorLoding('Incorrect_mailbox_format'.tr);
  //   } else if (_pwdController.text == "") {
  //     errorLoding('passwordEmpty'.tr);
  //   } else {
  //     if (newVal) {
  //       sendOtp();
  //     }
  //     startCount = newVal;
  //     update(['countdown']);
  //   }
  // }

  ///驗證驗證碼
  void verifyOtp({required String verifyCode, required LoginModel data}) async {
    showLoding('Verifying...');
    Dio dio = Dio();
    dio.options.baseUrl = Config.baseurl;
    dio.options.contentType = "application/json; charset=utf-8";
    dio.options.connectTimeout = const Duration(seconds: 10);
    dio.options.responseType = ResponseType.plain;
    dio.options.headers = {HttpHeaders.contentTypeHeader: "application/x-www-form-urlencoded"};
    try {
      var response = await dio.post(Config.verifyCode, data: {"verifyCode": verifyCode});
      if (response.statusCode == 200) {
        final josn = jsonDecode(response.data);

        if (josn['status'] == 200) {
          final url = data.data!.webSit;
          if (url != null) {
            box.write("loadingUrl", url);
            if (isChecked.value) {
              box.write("company", _companyController.text);
              box.write("cashier", _cashierController.text);
              box.write("user", _userController.text);
              box.write("pwd", _pwdController.text);
            }
            successLoding('loginSucceed'.tr);
            _verifyController.text = "";
            Get.offAllNamed(Routes.HOME);
          } else {
            errorLoding('websiteNotExist'.tr);
          }
        } else if (josn['status'] == 0) {
          errorLoding('codeExpired'.tr);
        } else if (josn['status'] == 1) {
          errorLoding('verifyCodeError'.tr);
        }
      }
    } on DioException {
      errorLoding('requestException'.tr);
    } finally {
      if (EasyLoading.isShow) {
        EasyLoading.dismiss();
      }
    }
  }

  ///显示隐藏密码
  void changPwdStatus() {
    isShowPassword.value = !isShowPassword.value;
  }

  void demo() {
    _companyController.text = "pericles";
    _cashierController.text = '101';
    _userController.text = "demo";
    _pwdController.text = "per1cles";
    isShowPassword.value = true;
    update(['body']);
  }
}
