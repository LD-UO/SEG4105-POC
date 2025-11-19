import 'package:flutter/material.dart';

import 'account_creation_screen.dart';
import 'logged_in_home.dart';
import 'history_screen.dart';
import 'stats_today_screen.dart';
import 'stats_trends_screen.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _username = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  void _goToUpload() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const LoggedInHome()),
    );
  }

  void _showComingSoon(String label) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$label not wired (POC).')),
    );
  }

  void _goToRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AccountCreationScreen()),
    );
  }

  void _goToStatsToday() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const StatsTodayScreen()),
    );
  }

  void _goToStatsTrends() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const StatsTrendsScreen()),
    );
  }

  void _goToHistory() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const HistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Auth'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => _showComingSoon('Settings'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              'Sign in',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showComingSoon('Institutional login'),
                icon: const Icon(Icons.school),
                label: const Text('Institutional login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF103B45),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showComingSoon('Google login'),
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4285F4),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _username,
              decoration: InputDecoration(
                hintText: 'Username',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _username.clear(),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _password,
              obscureText: true,
              decoration: InputDecoration(
                hintText: 'Password',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => _password.clear(),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                OutlinedButton(
                  onPressed: _goToUpload,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  child: const Text('Sign in'),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _goToRegister,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 24,
                    ),
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
            // const SizedBox(height: 24),
            // Wrap(
            //   spacing: 12,
            //   children: [
            //     ElevatedButton(
            //       onPressed: _goToStatsToday,
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.red,
            //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            //       ),
            //       child: const Text('Stats Today'),
            //     ),
            //     ElevatedButton(
            //       onPressed: _goToStatsTrends,
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.red,
            //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            //       ),
            //       child: const Text('Stats Trends'),
            //     ),
            //     ElevatedButton(
            //       onPressed: _goToHistory,
            //       style: ElevatedButton.styleFrom(
            //         backgroundColor: Colors.red,
            //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            //       ),
            //       child: const Text('History'),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }
}
