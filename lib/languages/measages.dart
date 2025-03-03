import 'package:get/get.dart';
import 'package:restadmin/languages/en_us.dart';
import 'package:restadmin/languages/zh_cn.dart';
import 'package:restadmin/languages/zh_hk.dart';

class Messages extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'zh_CN': zhCN,
        'zh_HK': zhHK,
        'en_us': enUS,
      };
}
