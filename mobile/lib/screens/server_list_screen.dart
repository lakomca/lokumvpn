import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/vpn_provider.dart';
import '../models/server.dart';
import '../providers/auth_provider.dart';
import '../widgets/widgets.dart';

class ServerListScreen extends StatelessWidget {
  const ServerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vpnProvider = Provider.of<VPNProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E27),
      appBar: AppBar(
        title: const Text('Select Server'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              vpnProvider.loadServers();
              vpnProvider.loadCountries();
            },
          ),
        ],
      ),
      body: SafeArea(
        child: vpnProvider.isLoading
            ? const LoadingIndicator(message: 'Loading servers...')
            : vpnProvider.error != null
                ? ErrorMessage(
                    message: vpnProvider.error!,
                    onRetry: () {
                      vpnProvider.loadServers();
                      vpnProvider.loadCountries();
                    },
                  )
                : Column(
                    children: [
                      // Countries Filter
                      if (vpnProvider.countries.isNotEmpty)
                        Container(
                          height: 60,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: vpnProvider.countries.length,
                            itemBuilder: (context, index) {
                              final country = vpnProvider.countries[index];
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: FilterChip(
                                  label: Text(country.name),
                                  selected: false,
                                  onSelected: (selected) {
                                    vpnProvider.loadServers(country: country.code);
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                      // Servers List
                      Expanded(
                        child: vpnProvider.servers.isEmpty
                            ? const EmptyState(
                                message: 'No servers available',
                                icon: Icons.cloud_off,
                              )
                            : RefreshIndicator(
                                onRefresh: () async {
                                  await vpnProvider.loadServers();
                                  await vpnProvider.loadCountries();
                                },
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(vertical: 8),
                                  itemCount: vpnProvider.servers.length,
                                  itemBuilder: (context, index) {
                                    final server = vpnProvider.servers[index];
                                    return ServerCard(
                                      server: server,
                                      onTap: () => _handleServerTap(context, server, vpnProvider),
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
      ),
    );
  }

  void _handleServerTap(BuildContext context, VPNServer server, VPNProvider vpnProvider) async {
    if (!server.isActive || vpnProvider.isLoading) return;

    // Check if config exists
    final configs = vpnProvider.configs
        .where((c) => c.serverId == server.id)
        .toList();

    if (configs.isEmpty) {
      // Create config first
      final success = await vpnProvider.createConfig(server.id);
      if (!success) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(vpnProvider.error ?? 'Failed to create configuration'),
              backgroundColor: Colors.red,
            ),
          );
        }
        return;
      }
    }

    // Get the config and connect
    await vpnProvider.loadConfigs();
    final config = vpnProvider.configs.firstWhere((c) => c.serverId == server.id);

    final connected = await vpnProvider.connect(config.id);
    if (context.mounted) {
      if (connected) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connected successfully'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(vpnProvider.error ?? 'Failed to connect'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}




