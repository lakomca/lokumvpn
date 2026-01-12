import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/vpn_provider.dart';
import 'login_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // User Info Card
            if (user != null)
              Card(
                color: const Color(0xFF1A1F3A),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Account',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildSettingRow(
                        Icons.person,
                        'Username',
                        user.username,
                      ),
                      const SizedBox(height: 12),
                      _buildSettingRow(
                        Icons.email,
                        'Email',
                        user.email,
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 16),
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
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text(
                      'Logout',
                      style: TextStyle(color: Colors.red),
                    ),
                    onTap: () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (context) => AlertDialog(
                          backgroundColor: const Color(0xFF1A1F3A),
                          title: const Text(
                            'Logout',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: const Text(
                            'Are you sure you want to logout?',
                            style: TextStyle(color: Colors.white),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, true),
                              child: const Text(
                                'Logout',
                                style: TextStyle(color: Colors.red),
                              ),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true && context.mounted) {
                        await authProvider.logout();
                        if (context.mounted) {
                          Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                            (route) => false,
                          );
                        }
                      }
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

  Widget _buildSettingRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey[400], size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}





