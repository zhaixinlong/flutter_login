import 'package:flutter/material.dart';

class ResetPage extends StatelessWidget {
  const ResetPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController accountController = TextEditingController();
    final TextEditingController newPasswordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("找回密码")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: accountController,
              decoration: const InputDecoration(
                labelText: "账号 / 手机号",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "新密码",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("密码重置成功")),
                );
              },
              child: const Text("确认修改"),
            ),
          ],
        ),
      ),
    );
  }
}
