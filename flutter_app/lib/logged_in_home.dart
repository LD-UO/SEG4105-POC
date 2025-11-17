import 'package:flutter/material.dart';

import 'history_screen.dart';
import 'photo_upload.dart';
import 'stats_today_screen.dart';

class LoggedInHome extends StatefulWidget {
  const LoggedInHome({super.key});

  @override
  State<LoggedInHome> createState() => _LoggedInHomeState();
}

class _LoggedInHomeState extends State<LoggedInHome> {
  int _index = 1; // default to Scan

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: const [
          StatsTodayScreen(embed: true),
          PhotoUploadPage(),
          HistoryScreen(embed: true),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        backgroundColor: Colors.red,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white70,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Today'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Scan'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
        ],
      ),
    );
  }
}
