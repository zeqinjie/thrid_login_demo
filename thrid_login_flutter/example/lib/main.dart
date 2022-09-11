/*
 * @Author: zhengzeqin
 * @Date: 2022-09-01 16:36:20
 * @LastEditTime: 2022-09-11 14:35:43
 * @Description: your project
 */
import 'package:example/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_line_sdk/flutter_line_sdk.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  /// line 渠道ID
  LineSDK.instance.setup("xxxxxxx").then((_) {});
  runApp(const MyApp());
}
