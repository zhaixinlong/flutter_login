# flutter_login

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

📦 项目结构
lib/
 ├── main.dart              # 入口文件
 ├── pages/
 │    ├── login_page.dart   # 登录页（账号/验证码切换）
 │    ├── reset_page.dart   # 找回密码页
 │    ├── home_page.dart    # 登录成功后的首页
 │    ├── profile_page.dart # 登录态页面1（个人中心）
 │    ├── state_page.dart   # 登录态页面2（不同效果）
 ├── services/
 │    └── auth_service.dart # 模拟用户认证逻辑
 └── widgets/
      └── custom_input.dart # 美化输入框组件
