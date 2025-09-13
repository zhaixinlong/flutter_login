import 'dart:async';
import 'package:flutter/material.dart';
import '../services/storage.dart';
import 'home_page.dart';
import 'reset_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isPasswordLogin = true;
  bool isRegister = false;

  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _verifyController = TextEditingController();

  int _countdown = 0; // 验证码倒计时
  Timer? _timer;
  String _smsCode = ""; // 模拟发送验证码

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    if (_accountController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("请输入手机号")),
      );
      return;
    }
    setState(() {
      _countdown = 60;
      _smsCode = "123456"; // 模拟固定验证码
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdown <= 1) {
        timer.cancel();
      }
      setState(() => _countdown--);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("验证码已发送：123456（模拟）")),
    );
  }

  Future<void> _login() async {
    final account = _accountController.text.trim();
    final pwd = _passwordController.text.trim();
    final code = _verifyController.text.trim();

    if (account.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("请输入账号/手机号")),
      );
      return;
    }

    if (isPasswordLogin) {
      if (pwd.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("请输入密码")),
        );
        return;
      }
    } else {
      if (code != _smsCode) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("验证码错误")),
        );
        return;
      }
    }

    // 模拟注册/登录
    await Storage.set("isLoggedIn", true);
    await Storage.setUser({
      "username": isRegister ? "用户$account" : "测试用户",
      "phone": account,
    });

    // Navigator.pushReplacement(
    //   context,
    //   MaterialPageRoute(builder: (_) => const MainPage()),
    // );

    // 如果你的项目后面可能有多层页面，最好用这个，把登录页之前的路由都清掉： 
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const HomePage()),
      (route) => false, // 移除所有之前的路由
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.lightBlueAccent],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 8,
            margin: const EdgeInsets.all(20),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ToggleButtons(
                    isSelected: [isPasswordLogin, !isPasswordLogin],
                    onPressed: (index) {
                      setState(() => isPasswordLogin = index == 0);
                    },
                    borderRadius: BorderRadius.circular(8),
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("账号密码登录"),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text("手机验证码登录"),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _accountController,
                    decoration: const InputDecoration(
                      labelText: "账号 / 手机号",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isPasswordLogin)
                    TextField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "密码",
                        border: OutlineInputBorder(),
                      ),
                    )
                  else
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _verifyController,
                            decoration: const InputDecoration(
                              labelText: "验证码",
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: _countdown == 0 ? _startCountdown : null,
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(100, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            _countdown == 0 ? "获取验证码" : "${_countdown}s",
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(45),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(isRegister ? "注册" : "登录"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          setState(() => isRegister = !isRegister);
                        },
                        child: Text(isRegister ? "已有账号？去登录" : "没有账号？去注册"),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ResetPage()),
                          );
                        },
                        child: const Text("忘记密码？"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
