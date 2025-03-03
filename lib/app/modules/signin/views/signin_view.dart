import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../utils/form_help.dart';
import '../../../../utils/main_image.dart';
import '../../../../utils/style.dart';
import '../controllers/signin_controller.dart';

class SigninView extends GetView<SigninController> {
  SigninView({super.key});
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final box = GetStorage();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: boxLinear,
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          child: Stack(
            children: [
              Column(
                children: [
                  SizedBox(height: Get.height * 0.08),
                  const MainImage(),
                  SizedBox(height: Get.height * 0.08),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Form(
                      key: formKey,
                      child: AnimationLimiter(
                        child: GetBuilder<SigninController>(
                          init: SigninController(),
                          initState: (_) {},
                          id: 'body',
                          builder: (ctl) {
                            return Column(
                              children: AnimationConfiguration.toStaggeredList(
                                duration: const Duration(milliseconds: 375),
                                childAnimationBuilder:
                                    (widget) => SlideAnimation(
                                      horizontalOffset: Get.width / 2,
                                      child: FadeInAnimation(child: widget),
                                    ),
                                children: [
                                  //公司
                                  FormHelper.textInput(
                                    controller: controller.companyController,
                                    icon: Icons.business,
                                    labelText: "companyID".tr,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'companyEmpty'.tr;
                                      }
                                      return null;
                                    },
                                    onChanged: (String? val) {
                                      ctl.pwdController.clear();
                                    },
                                  ),
                                  const SizedBox(height: 15),

                                  //收銀機
                                  FormHelper.textInput(
                                    controller: controller.cashierController,
                                    icon: Icons.price_change,
                                    labelText: "Cashier".tr,
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'cashierEmpty'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  //用户
                                  FormHelper.textInput(
                                    controller: controller.userController,
                                    icon: Icons.person,
                                    labelText: "User".tr,
                                    keyboardType: TextInputType.text,
                                    validator: (value) {
                                      if (value!.isEmpty) {
                                        return 'userEmpty'.tr;
                                      }
                                      return null;
                                    },
                                  ),
                                  const SizedBox(height: 15),
                                  //密码
                                  Obx(
                                    () => FormHelper.textInput(
                                      controller: controller.pwdController,
                                      icon: Icons.lock_outline,
                                      labelText: "password".tr,
                                      keyboardType: TextInputType.visiblePassword,
                                      validator: (value) {
                                        if (value!.isEmpty) {
                                          return 'passwordEmpty'.tr;
                                        }
                                        return null;
                                      },
                                      obscureText:
                                          ((controller.companyController.text == "pericles" &&
                                                  controller.pwdController.text == "per1cles"))
                                              ? true
                                              : controller.isShowPassword.value,
                                      suffixIcon: Padding(
                                        padding: const EdgeInsets.only(right: 8.0),
                                        child: IconButton(
                                          color: Colors.white70,
                                          icon:
                                              controller.isShowPassword.value
                                                  ? const Icon(Icons.visibility)
                                                  : const Icon(Icons.visibility_off),
                                          onPressed: controller.changPwdStatus,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(height: 15),

                                  // //验证码
                                  // GetBuilder<SigninController>(
                                  //   init: SigninController(),
                                  //   id: 'countdown',
                                  //   initState: (_) {},
                                  //   builder: (_) {
                                  //     return FormHelper.textInput(
                                  //       controller: controller.verifyController,
                                  //       icon: Icons.verified_user,
                                  //       labelText: "verifyCode".tr,
                                  //       keyboardType: TextInputType.number,
                                  //       suffixIcon: Padding(
                                  //         padding:
                                  //             const EdgeInsets.only(right: 8.0),
                                  //         child: TextButton(
                                  //           onPressed: () {
                                  //             _.startCount
                                  //                 ? null
                                  //                 : _.changeStartCount(true);
                                  //           },
                                  //           child: _.startCount
                                  //               ? Countdown(
                                  //                   controller:
                                  //                       _.countdownController,
                                  //                   seconds: 180,
                                  //                   build: (_, double time) =>
                                  //                       AutoSizeText(
                                  //                     "${time.toInt().toString()}s ${"resend".tr}",
                                  //                     style: TextStyle(
                                  //                       fontSize: 16,
                                  //                       color: Colors.white
                                  //                           .withOpacity(.4),
                                  //                     ),
                                  //                     maxLines: 1,
                                  //                   ),
                                  //                   onFinished: () {
                                  //                     _.changeStartCount(false);
                                  //                   },
                                  //                 )
                                  //               : AutoSizeText(
                                  //                   'sendVerifyCode'.tr,
                                  //                   style: const TextStyle(
                                  //                     fontSize: 16,
                                  //                     color: Color.fromARGB(
                                  //                         255, 40, 43, 245),
                                  //                   ),
                                  //                   maxLines: 1,
                                  //                 ),
                                  //         ),
                                  //       ),
                                  //       validator: (value) {
                                  //         if (value!.isEmpty) {
                                  //           return 'verifyCodeEmpty'.tr;
                                  //         }
                                  //         return null;
                                  //       },
                                  //     );
                                  //   },
                                  // ),
                                  const SizedBox(height: 8),
                                  //记住我
                                  Row(
                                    children: [
                                      GetBuilder<SigninController>(
                                        init: SigninController(),
                                        id: 'check',
                                        initState: (_) {},
                                        builder: (_) {
                                          return Expanded(
                                            child: CheckboxListTile(
                                              controlAffinity: ListTileControlAffinity.leading,
                                              activeColor: Colors.green,
                                              contentPadding: EdgeInsets.zero,
                                              title: Text(
                                                "rememberMe".tr,
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.white.withValues(alpha: .9),
                                                ),
                                              ),
                                              value: controller.isChecked.value,
                                              onChanged: ((value) {
                                                controller.changeCheck(value!);
                                              }),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 15),
                                  //提交的按钮
                                  FormHelper.submitUIButton(context, "login".tr, () {
                                    if (formKey.currentState!.validate()) {
                                      controller.login();
                                    }
                                  }),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Positioned(
                right: Get.width * 0.01,
                top: context.mediaQuery.padding.top,
                child: DropdownButton(
                  underline: const SizedBox(),
                  iconSize: 30,
                  iconEnabledColor: Colors.white.withValues(alpha: .9),
                  dropdownColor: Colors.grey[900],
                  style: TextStyle(fontSize: 16, color: Colors.white.withValues(alpha: .9)),
                  value: box.read("localLang") ?? Get.locale.toString(),
                  items: const [
                    DropdownMenuItem(value: 'zh_CN', child: Text('简体')),
                    DropdownMenuItem(value: 'zh_HK', child: Text('繁体')),
                    DropdownMenuItem(value: 'en_us', child: Text('English')),
                  ],
                  onChanged: (value) {
                    Locale languageCode =
                        value == "zh_CN"
                            ? const Locale("zh", "CN")
                            : value == "zh_HK"
                            ? const Locale("zh", "HK")
                            : const Locale("en", "us");
                    box.remove("localLang");
                    box.write("localLang", value);
                    Get.updateLocale(languageCode);
                  },
                ),
              ),
              Positioned(
                left: Get.width * 0.012,
                top: context.mediaQuery.padding.top,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white.withValues(alpha: .7),
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    elevation: 0,
                    side: BorderSide(color: Colors.white.withValues(alpha: .7)),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  ),
                  onPressed: () {
                    controller.demo();
                  },
                  child: Text("demo".tr, style: const TextStyle(fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
