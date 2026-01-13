import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // VPN Settings
            Card(
              color: const Color(0xFF1A1F3A),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.security, color: Color(0xFF6C63FF)),
                    title: const Text(
                      'Ad Blocking',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Block ads and trackers',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // Toggle ad blocking
                      },
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.shield, color: Color(0xFF6C63FF)),
                    title: const Text(
                      'Malware Protection',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Block malware and phishing',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    trailing: Switch(
                      value: true,
                      onChanged: (value) {
                        // Toggle malware protection
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // App Settings
            Card(
              color: const Color(0xFF1A1F3A),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.info, color: Color(0xFF6C63FF)),
                    title: const Text(
                      'About',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: Text(
                      'Lokum VPN v1.0.0',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    onTap: () {
                      showAboutDialog(
                        context: context,
                        applicationName: 'Lokum VPN',
                        applicationVersion: '1.0.0',
                        applicationLegalese: 'Privacy & Security',
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





