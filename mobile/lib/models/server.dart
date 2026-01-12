/// VPN Server model
class VPNServer {
  final int id;
  final String name;
  final String country;
  final String countryCode;
  final String? region;
  final String hostname;
  final String ipAddress;
  final String? ipv6Address;
  final int port;
  final String publicKey;
  final String endpoint;
  final bool isActive;
  final double loadPercentage;
  final double latencyMs;
  final double bandwidthMbps;
  final int maxUsers;
  final int currentUsers;
  final DateTime createdAt;

  VPNServer({
    required this.id,
    required this.name,
    required this.country,
    required this.countryCode,
    this.region,
    required this.hostname,
    required this.ipAddress,
    this.ipv6Address,
    required this.port,
    required this.publicKey,
    required this.endpoint,
    required this.isActive,
    required this.loadPercentage,
    required this.latencyMs,
    required this.bandwidthMbps,
    required this.maxUsers,
    required this.currentUsers,
    required this.createdAt,
  });

  factory VPNServer.fromJson(Map<String, dynamic> json) {
    return VPNServer(
      id: json['id'] as int,
      name: json['name'] as String,
      country: json['country'] as String,
      countryCode: json['country_code'] as String,
      region: json['region'] as String?,
      hostname: json['hostname'] as String,
      ipAddress: json['ip_address'] as String,
      ipv6Address: json['ipv6_address'] as String?,
      port: json['port'] as int,
      publicKey: json['public_key'] as String,
      endpoint: json['endpoint'] as String,
      isActive: json['is_active'] as bool,
      loadPercentage: (json['load_percentage'] as num).toDouble(),
      latencyMs: (json['latency_ms'] as num).toDouble(),
      bandwidthMbps: (json['bandwidth_mbps'] as num).toDouble(),
      maxUsers: json['max_users'] as int,
      currentUsers: json['current_users'] as int,
      createdAt: DateTime.parse(json['created_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'country': country,
      'country_code': countryCode,
      'region': region,
      'hostname': hostname,
      'ip_address': ipAddress,
      'ipv6_address': ipv6Address,
      'port': port,
      'public_key': publicKey,
      'endpoint': endpoint,
      'is_active': isActive,
      'load_percentage': loadPercentage,
      'latency_ms': latencyMs,
      'bandwidth_mbps': bandwidthMbps,
      'max_users': maxUsers,
      'current_users': currentUsers,
      'created_at': createdAt.toIso8601String(),
    };
  }
}

/// Country model
class Country {
  final String code;
  final String name;
  final int serverCount;

  Country({
    required this.code,
    required this.name,
    required this.serverCount,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      code: json['code'] as String,
      name: json['name'] as String,
      serverCount: json['server_count'] as int,
    );
  }
}

/// Server status
class ServerStatus {
  final int serverId;
  final bool isOnline;
  final double loadPercentage;
  final double latencyMs;
  final int currentUsers;

  ServerStatus({
    required this.serverId,
    required this.isOnline,
    required this.loadPercentage,
    required this.latencyMs,
    required this.currentUsers,
  });

  factory ServerStatus.fromJson(Map<String, dynamic> json) {
    return ServerStatus(
      serverId: json['server_id'] as int,
      isOnline: json['is_online'] as bool,
      loadPercentage: (json['load_percentage'] as num).toDouble(),
      latencyMs: (json['latency_ms'] as num).toDouble(),
      currentUsers: json['current_users'] as int,
    );
  }
}





