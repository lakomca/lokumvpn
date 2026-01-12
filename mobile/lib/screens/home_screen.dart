import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vpn_provider.dart';
import '../providers/auth_provider.dart';
import 'server_list_screen.dart';
import 'stats_screen.dart';
import 'settings_screen.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final vpnProvider = Provider.of<VPNProvider>(context, listen: false);
      vpnProvider.loadServers();
      vpnProvider.loadConfigs();
      vpnProvider.refreshConnectionStatus();
      vpnProvider.loadStats();
      vpnProvider.loadProtectionStats();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          ConnectionScreen(),
          ServerListScreen(),
          StatsScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        backgroundColor: const Color(0xFF1A1F3A),
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.server_outlined),
            selectedIcon: Icon(Icons.server),
            label: 'Servers',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Stats',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

class ConnectionScreen extends StatelessWidget {
  const ConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vpnProvider = Provider.of<VPNProvider>(context);
    final connectionStatus = vpnProvider.connectionStatus;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: const Text('Lokum VPN'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              vpnProvider.refreshConnectionStatus();
              vpnProvider.loadStats();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Connection Status Card
              ConnectionStatusCard(
                status: connectionStatus,
                onConnect: vpnProvider.isLoading
                    ? null
                    : () {
                        // Navigate to server selection if no connection
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const ServerListScreen(),
                          ),
                        );
                      },
                onDisconnect: vpnProvider.isLoading
                    ? null
                    : () async {
                        await vpnProvider.disconnect();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Disconnected'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
              ),
              const SizedBox(height: 24),
              // Protection Status
              Card(
                color: const Color(0xFF1A1F3A),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Protection Status',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildProtectionRow(
                        'Ad Blocking',
                        vpnProvider.protectionStatus?.adblockEnabled ?? false,
                      ),
                      const SizedBox(height: 12),
                      _buildProtectionRow(
                        'Malware Protection',
                        vpnProvider.protectionStatus?.malwareProtectionEnabled ??
                            false,
                      ),
                    ],
                  ),
                ),
              ),
              // Quick Stats
              if (connectionStatus?.isConnected ?? false) ...[
                const SizedBox(height: 24),
                Card(
                  color: const Color(0xFF1A1F3A),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Session Stats',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildStatRow('Data Sent', connectionStatus!.formattedDataSent),
                        const SizedBox(height: 12),
                        _buildStatRow(
                            'Data Received', connectionStatus.formattedDataReceived),
                        const SizedBox(height: 12),
                        _buildStatRow('Duration', connectionStatus.formattedDuration),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProtectionRow(String label, bool enabled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Colors.white)),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: enabled ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            enabled ? 'Active' : 'Inactive',
            style: TextStyle(
              color: enabled ? Colors.green : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[400])),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }
}




