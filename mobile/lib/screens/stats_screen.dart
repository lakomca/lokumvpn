import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vpn_provider.dart';
import '../widgets/widgets.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vpnProvider = Provider.of<VPNProvider>(context);
    final stats = vpnProvider.stats;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: const Text('Statistics'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              vpnProvider.loadStats();
              vpnProvider.loadProtectionStats();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await vpnProvider.loadStats();
            await vpnProvider.loadProtectionStats();
          },
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (stats == null)
                  const LoadingIndicator(message: 'Loading statistics...')
                else ...[
                  // Overall Stats Card
                  Card(
                    color: const Color(0xFF1A1F3A),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Overall Statistics',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          _buildStatRow(
                            'Total Connections',
                            stats.totalConnections.toString(),
                            Icons.link,
                          ),
                          const SizedBox(height: 16),
                          _buildStatRow(
                            'Total Data Transferred',
                            '${stats.totalDataGb.toStringAsFixed(2)} GB',
                            Icons.cloud_upload,
                          ),
                          const SizedBox(height: 16),
                          _buildStatRow(
                            'Total Time Connected',
                            '${stats.totalTimeHours.toStringAsFixed(2)} hours',
                            Icons.timer,
                          ),
                          const SizedBox(height: 16),
                          _buildStatRow(
                            'Connections Today',
                            stats.connectionsToday.toString(),
                            Icons.today,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Protection Stats Card
                  Card(
                    color: const Color(0xFF1A1F3A),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Protection Statistics',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 24),
                          if (vpnProvider.protectionStats != null) ...[
                            _buildStatRow(
                              'Ad Blocked Domains',
                              vpnProvider.protectionStats!.adblockDomains
                                  .toString(),
                              Icons.block,
                            ),
                            const SizedBox(height: 16),
                            _buildStatRow(
                              'Malware Blocked Domains',
                              vpnProvider.protectionStats!.malwareDomains
                                  .toString(),
                              Icons.security,
                            ),
                          ] else
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF).withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFF6C63FF)),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}




