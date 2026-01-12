/// Protection statistics
class ProtectionStats {
  final int adblockDomains;
  final int malwareDomains;
  final String adblockLastUpdate;
  final String malwareLastUpdate;

  ProtectionStats({
    required this.adblockDomains,
    required this.malwareDomains,
    required this.adblockLastUpdate,
    required this.malwareLastUpdate,
  });

  factory ProtectionStats.fromJson(Map<String, dynamic> json) {
    return ProtectionStats(
      adblockDomains: json['adblock_domains'] as int? ?? 0,
      malwareDomains: json['malware_domains'] as int? ?? 0,
      adblockLastUpdate: json['adblock_last_update'] as String? ?? '',
      malwareLastUpdate: json['malware_last_update'] as String? ?? '',
    );
  }
}

/// Protection status
class ProtectionStatus {
  final bool adblockEnabled;
  final bool malwareProtectionEnabled;
  final bool adblockNeedsUpdate;
  final bool malwareNeedsUpdate;
  final int adblockCount;
  final int malwareCount;

  ProtectionStatus({
    required this.adblockEnabled,
    required this.malwareProtectionEnabled,
    required this.adblockNeedsUpdate,
    required this.malwareNeedsUpdate,
    required this.adblockCount,
    required this.malwareCount,
  });

  factory ProtectionStatus.fromJson(Map<String, dynamic> json) {
    return ProtectionStatus(
      adblockEnabled: json['adblock_enabled'] as bool? ?? true,
      malwareProtectionEnabled: json['malware_protection_enabled'] as bool? ?? true,
      adblockNeedsUpdate: json['adblock_needs_update'] as bool? ?? false,
      malwareNeedsUpdate: json['malware_needs_update'] as bool? ?? false,
      adblockCount: json['adblock_count'] as int? ?? 0,
      malwareCount: json['malware_count'] as int? ?? 0,
    );
  }
}

/// Domain block check result
class BlockCheckResult {
  final String domain;
  final bool blocked;
  final String reason;

  BlockCheckResult({
    required this.domain,
    required this.blocked,
    required this.reason,
  });

  factory BlockCheckResult.fromJson(Map<String, dynamic> json) {
    return BlockCheckResult(
      domain: json['domain'] as String,
      blocked: json['blocked'] as bool,
      reason: json['reason'] as String? ?? '',
    );
  }
}





