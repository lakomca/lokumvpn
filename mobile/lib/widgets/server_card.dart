import 'package:flutter/material.dart';
import '../models/server.dart';

/// Reusable server card widget
class ServerCard extends StatelessWidget {
  final VPNServer server;
  final VoidCallback? onTap;
  final bool isSelected;

  const ServerCard({
    super.key,
    required this.server,
    this.onTap,
    this.isSelected = false,
  });

  String _getStatusText() {
    if (!server.isActive) return 'Offline';
    if (server.loadPercentage > 80) return 'High Load';
    if (server.latencyMs > 100) return 'High Latency';
    return 'Available';
  }

  Color _getStatusColor() {
    if (!server.isActive) return Colors.red;
    if (server.loadPercentage > 80) return Colors.orange;
    if (server.latencyMs > 100) return Colors.amber;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: isSelected
          ? Colors.blue.withOpacity(0.2)
          : const Color(0xFF1A1F3A),
      elevation: isSelected ? 4 : 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          server.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${server.country}${server.region != null ? " - ${server.region}" : ""}',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor().withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: _getStatusColor(),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      _getStatusText(),
                      style: TextStyle(
                        color: _getStatusColor(),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  _buildStatItem(
                    Icons.speed,
                    '${server.latencyMs.toStringAsFixed(0)} ms',
                    Colors.cyan,
                  ),
                  const SizedBox(width: 24),
                  _buildStatItem(
                    Icons.people,
                    '${server.currentUsers}/${server.maxUsers}',
                    Colors.purple,
                  ),
                  const SizedBox(width: 24),
                  _buildStatItem(
                    Icons.trending_up,
                    '${server.loadPercentage.toStringAsFixed(0)}%',
                    _getStatusColor(),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            color: Colors.grey.shade300,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}


