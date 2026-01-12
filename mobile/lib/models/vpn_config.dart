/// VPN Configuration model
class VPNConfig {
  final int id;
  final int serverId;
  final String serverName;
  final String serverCountry;
  final String publicKey;
  final String address;
  final String dnsServers;
  final String configContent;
  final bool isActive;
  final DateTime createdAt;

  VPNConfig({
    required this.id,
    required this.serverId,
    required this.serverName,
    required this.serverCountry,
    required this.publicKey,
    required this.address,
    required this.dnsServers,
    required this.configContent,
    required this.isActive,
    required this.createdAt,
  });

  factory VPNConfig.fromJson(Map<String, dynamic> json) {
    return VPNConfig(
      id: json['id'] as int,
      serverId: json['server_id'] as int,
      serverName: json['server_name'] as String,
      serverCountry: json['server_country'] as String,
      publicKey: json['public_key'] as String,
      address: json['address'] as String,
      dnsServers: json['dns_servers'] as String,
      configContent: json['config_content'] as String,
      isActive: json['is_active'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'server_id': serverId,
      'server_name': serverName,
      'server_country': serverCountry,
      'public_key': publicKey,
      'address': address,
      'dns_servers': dnsServers,
      'config_content': configContent,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Connection status
class ConnectionStatus {
  final bool isConnected;
  final int? serverId;
  final String? serverName;
  final int bytesSent;
  final int bytesReceived;
  final int durationSeconds;
  final DateTime? connectedAt;

  ConnectionStatus({
    required this.isConnected,
    this.serverId,
    this.serverName,
    required this.bytesSent,
    required this.bytesReceived,
    required this.durationSeconds,
    this.connectedAt,
  });

  factory ConnectionStatus.fromJson(Map<String, dynamic> json) {
    return ConnectionStatus(
      isConnected: json['is_connected'] as bool,
      serverId: json['server_id'] as int?,
      serverName: json['server_name'] as String?,
      bytesSent: json['bytes_sent'] as int? ?? 0,
      bytesReceived: json['bytes_received'] as int? ?? 0,
      durationSeconds: json['duration_seconds'] as int? ?? 0,
      connectedAt: json['connected_at'] != null
          ? DateTime.parse(json['connected_at'] as String)
          : null,
    );
  }

  String get formattedDataSent {
    if (bytesSent < 1024) return '$bytesSent B';
    if (bytesSent < 1024 * 1024) return '${(bytesSent / 1024).toStringAsFixed(2)} KB';
    if (bytesSent < 1024 * 1024 * 1024) {
      return '${(bytesSent / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytesSent / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String get formattedDataReceived {
    if (bytesReceived < 1024) return '$bytesReceived B';
    if (bytesReceived < 1024 * 1024) {
      return '${(bytesReceived / 1024).toStringAsFixed(2)} KB';
    }
    if (bytesReceived < 1024 * 1024 * 1024) {
      return '${(bytesReceived / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytesReceived / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  String get formattedDuration {
    final hours = durationSeconds ~/ 3600;
    final minutes = (durationSeconds % 3600) ~/ 60;
    final seconds = durationSeconds % 60;
    
    if (hours > 0) {
      return '${hours}h ${minutes}m ${seconds}s';
    } else if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    } else {
      return '${seconds}s';
    }
  }
}

/// Statistics
class VPNStats {
  final int totalConnections;
  final bool activeConnection;
  final double totalDataMb;
  final double totalDataGb;
  final double totalTimeHours;
  final int connectionsToday;
  final int? currentServer;

  VPNStats({
    required this.totalConnections,
    required this.activeConnection,
    required this.totalDataMb,
    required this.totalDataGb,
    required this.totalTimeHours,
    required this.connectionsToday,
    this.currentServer,
  });

  factory VPNStats.fromJson(Map<String, dynamic> json) {
    return VPNStats(
      totalConnections: json['total_connections'] as int? ?? 0,
      activeConnection: json['active_connection'] as bool? ?? false,
      totalDataMb: (json['total_data_mb'] as num?)?.toDouble() ?? 0.0,
      totalDataGb: (json['total_data_gb'] as num?)?.toDouble() ?? 0.0,
      totalTimeHours: (json['total_time_hours'] as num?)?.toDouble() ?? 0.0,
      connectionsToday: json['connections_today'] as int? ?? 0,
      currentServer: json['current_server'] as int?,
    );
  }
}





