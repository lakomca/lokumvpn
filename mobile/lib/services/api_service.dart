/// API Service for Lokum VPN backend
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config/config.dart';
import '../models/user.dart';
import '../models/server.dart';
import '../models/vpn_config.dart';
import '../models/protection.dart';

class ApiService {
  late Dio _dio;
  String? _token;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: AppConfig.apiBaseUrl,
      connectTimeout: AppConfig.connectionTimeout,
      receiveTimeout: AppConfig.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
      },
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        return handler.next(options);
      },
      onError: (error, handler) {
        if (error.response?.statusCode == 401) {
          // Handle unauthorized - clear token
          _token = null;
        }
        return handler.next(error);
      },
    ));

    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(AppConfig.tokenKey);
    if (_token != null) {
      _dio.options.headers['Authorization'] = 'Bearer $_token';
    }
  }

  Future<void> setToken(String token) async {
    _token = token;
    _dio.options.headers['Authorization'] = 'Bearer $token';
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AppConfig.tokenKey, token);
  }

  Future<void> clearToken() async {
    _token = null;
    _dio.options.headers.remove('Authorization');
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConfig.tokenKey);
  }

  // Authentication
  Future<AuthResponse> login(String username, String password) async {
    try {
      final response = await _dio.post(
        '${AppConfig.authEndpoint}/login',
        data: {
          'username': username,
          'password': password,
        },
      );
      final authResponse = AuthResponse.fromJson(response.data);
      await setToken(authResponse.accessToken);
      return authResponse;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> register(String username, String email, String password) async {
    try {
      final response = await _dio.post(
        '${AppConfig.authEndpoint}/register',
        data: {
          'username': username,
          'email': email,
          'password': password,
        },
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> getCurrentUser() async {
    try {
      final response = await _dio.get('${AppConfig.authEndpoint}/me');
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // VPN Servers
  Future<List<VPNServer>> getServers({String? country, bool activeOnly = true}) async {
    try {
      final queryParams = <String, dynamic>{
        'active_only': activeOnly,
      };
      if (country != null) {
        queryParams['country'] = country;
      }

      final response = await _dio.get(
        '${AppConfig.serversEndpoint}/',
        queryParameters: queryParams,
      );
      final data = response.data as Map<String, dynamic>;
      final servers = data['servers'] as List;
      return servers.map((s) => VPNServer.fromJson(s as Map<String, dynamic>)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<Country>> getCountries() async {
    try {
      final response = await _dio.get('${AppConfig.serversEndpoint}/countries');
      final data = response.data as Map<String, dynamic>;
      final countries = data['countries'] as List;
      return countries
          .map((c) => Country.fromJson(c as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<VPNServer> getServer(int serverId) async {
    try {
      final response = await _dio.get('${AppConfig.serversEndpoint}/$serverId');
      return VPNServer.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ServerStatus> getServerStatus(int serverId) async {
    try {
      final response = await _dio.get('${AppConfig.serversEndpoint}/$serverId/status');
      return ServerStatus.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // VPN Configuration
  Future<VPNConfig> createConfig(int serverId, {String? dnsServers}) async {
    try {
      final response = await _dio.post(
        '${AppConfig.configEndpoint}/',
        data: {
          'server_id': serverId,
          if (dnsServers != null) 'dns_servers': dnsServers,
        },
      );
      return VPNConfig.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<List<VPNConfig>> getConfigs() async {
    try {
      final response = await _dio.get('${AppConfig.configEndpoint}/');
      final data = response.data as List;
      return data.map((c) => VPNConfig.fromJson(c as Map<String, dynamic>)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<VPNConfig> getConfig(int configId) async {
    try {
      final response = await _dio.get('${AppConfig.configEndpoint}/$configId');
      return VPNConfig.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> deleteConfig(int configId) async {
    try {
      await _dio.delete('${AppConfig.configEndpoint}/$configId');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Connection Management
  Future<ConnectionStatus> connect(int configId) async {
    try {
      final response = await _dio.post(
        '${AppConfig.configEndpoint}/connect',
        data: {'config_id': configId},
      );
      return ConnectionStatus.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ConnectionStatus> disconnect() async {
    try {
      final response = await _dio.post('${AppConfig.configEndpoint}/disconnect');
      return ConnectionStatus.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ConnectionStatus> getConnectionStatus() async {
    try {
      final response = await _dio.get('${AppConfig.configEndpoint}/status');
      return ConnectionStatus.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Statistics
  Future<VPNStats> getStats() async {
    try {
      final response = await _dio.get('${AppConfig.statsEndpoint}/summary');
      return VPNStats.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Protection
  Future<ProtectionStats> getProtectionStats() async {
    try {
      final response = await _dio.get('${AppConfig.protectionEndpoint}/stats');
      return ProtectionStats.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<ProtectionStatus> getProtectionStatus() async {
    try {
      final response = await _dio.get('${AppConfig.protectionEndpoint}/status');
      return ProtectionStatus.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<BlockCheckResult> checkDomain(String domain) async {
    try {
      final response = await _dio.post(
        '${AppConfig.protectionEndpoint}/check',
        data: {'domain': domain},
      );
      return BlockCheckResult.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        // Try to get detailed error message
        final responseData = error.response?.data;
        String message = 'An error occurred';
        
        if (responseData is Map) {
          // Try multiple possible error message fields
          message = responseData['detail'] ?? 
                   responseData['message'] ?? 
                   responseData['error'] ??
                   responseData.toString();
        } else if (responseData is String) {
          message = responseData;
        }
        
        // If it's an internal server error, provide helpful message
        if (error.response?.statusCode == 500) {
          message = 'Server error: $message. Please check backend logs or contact support.';
        }
        
        return Exception(message);
      } else if (error.type == DioExceptionType.connectionTimeout ||
          error.type == DioExceptionType.receiveTimeout) {
        return Exception('Connection timeout. Please check your internet connection.');
      } else if (error.type == DioExceptionType.connectionError) {
        return Exception('Cannot connect to server. Please check if the server is running.');
      } else {
        return Exception('Network error: ${error.message}');
      }
    }
    return Exception('Unexpected error: $error');
  }
}





