import 'package:flutter/material.dart';
import '../services/storage.dart';
import 'login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userInfo;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await Storage.getUser();
    setState(() => userInfo = user);
  }

  Future<void> _logout(BuildContext context) async {
    await Storage.set("isLoggedIn", false);
    await Storage.remove("userInfo");

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginPage()),
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (userInfo == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_circle, size: 100, color: Colors.blue.shade400),
          const SizedBox(height: 20),
          Text("用户名: ${userInfo!["username"]}", style: const TextStyle(fontSize: 18)),
          Text("手机号: ${userInfo!["phone"]}", style: const TextStyle(fontSize: 18)),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => _logout(context),
            icon: const Icon(Icons.logout),
            label: const Text("退出登录"),
          ),
        ],
      ),
    );
  }
}
