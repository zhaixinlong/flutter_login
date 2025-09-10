import 'dart:async';
import 'package:flutter/material.dart';
import '../services/storage.dart';

class ResetPage extends StatefulWidget {
  const ResetPage({super.key});

  @override
  State<ResetPage> createState() => _ResetPageState();
}

class _ResetPageState extends State<ResetPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _newPwdController = TextEditingController();

  int _countdown = 0;
  Timer? _timer;
  String _smsCode = "";

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startCountdown() {
    if (_phoneController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("请输入手机号")),
      );
      return;
    }
    setState(() {
      _countdown = 60;
      _smsCode = "123456"; // 模拟验证码
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

  Future<void> _resetPassword() async {
    final phone = _phoneController.text.trim();
    final code = _codeController.text.trim();
    final newPwd = _newPwdController.text.trim();

    if (phone.isEmpty || code.isEmpty || newPwd.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("请填写完整信息")),
      );
      return;
    }

    if (code != _smsCode) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("验证码错误")),
      );
      return;
    }

    // ⚠️ 这里只是模拟保存新密码，并没有校验旧密码或真实更新数据库
    await Storage.set("userPwd_$phone", newPwd);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("密码重置成功，请重新登录")),
    );

    Navigator.pop(context); // 返回登录页
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("找回密码")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(
                labelText: "手机号",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _codeController,
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
            const SizedBox(height: 15),
            TextField(
              controller: _newPwdController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "新密码",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: _resetPassword,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(45),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text("重置密码"),
            ),
          ],
        ),
      ),
    );
  }
}
