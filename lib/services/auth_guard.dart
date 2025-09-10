import 'package:flutter/material.dart';
import 'storage.dart';
import '../pages/login_page.dart';

class AuthGuard {
  /// 校验是否已登录
  static Future<bool> checkLogin(BuildContext context) async {
    final isLoggedIn = await Storage.get("isLoggedIn") ?? false;

    if (!isLoggedIn) {
      // 未登录 → 跳转到登录页
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
        (_) => false,
      );
      return false;
    }
    return true;
  }
}
