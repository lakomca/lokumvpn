/// VPN Provider for managing VPN state
import 'package:flutter/foundation.dart';
import 'dart:async';
import '../models/server.dart';
import '../models/vpn_config.dart';
import '../models/protection.dart';
import '../services/api_service.dart';

class VPNProvider with ChangeNotifier {
  final ApiService _apiService;
  
  List<VPNServer> _servers = [];
  List<Country> _countries = [];
  List<VPNConfig> _configs = [];
  ConnectionStatus? _connectionStatus;
  VPNStats? _stats;
  ProtectionStats? _protectionStats;
  ProtectionStatus? _protectionStatus;
  
  bool _isLoading = false;
  String? _error;
  Timer? _statusTimer;

  VPNProvider(this._apiService) {
    _startStatusPolling();
  }

  List<VPNServer> get servers => _servers;
  List<Country> get countries => _countries;
  List<VPNConfig> get configs => _configs;
  ConnectionStatus? get connectionStatus => _connectionStatus;
  VPNStats? get stats => _stats;
  ProtectionStats? get protectionStats => _protectionStats;
  ProtectionStatus? get protectionStatus => _protectionStatus;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isConnected => _connectionStatus?.isConnected ?? false;

  Future<void> loadServers({String? country}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _servers = await _apiService.getServers(country: country);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadCountries() async {
    try {
      _countries = await _apiService.getCountries();
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  Future<void> loadConfigs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _configs = await _apiService.getConfigs();
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createConfig(int serverId, {String? dnsServers}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final config = await _apiService.createConfig(serverId, dnsServers: dnsServers);
      await loadConfigs();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> connect(int configId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _connectionStatus = await _apiService.connect(configId);
      _isLoading = false;
      // Immediately refresh status to get latest data
      await refreshConnectionStatus();
      await loadStats();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> disconnect() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _connectionStatus = await _apiService.disconnect();
      _isLoading = false;
      // Immediately refresh status to ensure disconnection is reflected
      await refreshConnectionStatus();
      await loadStats();
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> refreshConnectionStatus() async {
    try {
      _connectionStatus = await _apiService.getConnectionStatus();
      notifyListeners();
    } catch (e) {
      // Silently fail - don't show error on background refresh
    }
  }

  Future<void> loadStats() async {
    try {
      _stats = await _apiService.getStats();
      notifyListeners();
    } catch (e) {
      // Silently fail
    }
  }

  Future<void> loadProtectionStats() async {
    try {
      _protectionStats = await _apiService.getProtectionStats();
      _protectionStatus = await _apiService.getProtectionStatus();
      notifyListeners();
    } catch (e) {
      // Silently fail
    }
  }

  void _startStatusPolling() {
    // Poll every 5 seconds when connected, every 30 seconds when disconnected
    _statusTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      if (isConnected) {
        // Active connection: poll frequently for real-time updates
        await refreshConnectionStatus();
        await loadStats();
      } else {
        // No connection: check less frequently to detect reconnections
        // Only check every 30 seconds (every 6th iteration)
        if (timer.tick % 6 == 0) {
          await refreshConnectionStatus();
        }
      }
    });
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}




