import 'package:flutter/material.dart';
import '../services/auth_guard.dart';
import 'state_page.dart';
import 'profile_page.dart';
import '../logger.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text("首页内容", style: TextStyle(fontSize: 20))),
    StatePage(),
    Center(child: Text("校验页面", style: TextStyle(fontSize: 20))),
    ProfilePage(),
  ];

  Future<void> _onTabTapped(int index) async {
    appLogger.d("点击了 $index");
    
    if (index == 2) {
      final ok = await AuthGuard.checkLogin(context);
      if (ok) setState(() => _currentIndex = index);
    } else {
      setState(() => _currentIndex = index);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onTabTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "首页"),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: "状态"),
          BottomNavigationBarItem(icon: Icon(Icons.verified_user), label: "校验"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "我的"),
        ],
      ),
    );
  }
}
