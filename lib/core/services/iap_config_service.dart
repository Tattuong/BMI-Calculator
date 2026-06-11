import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../constants/iap_constants.dart';
import '../../models/iap_config.dart';
import 'storage_service.dart';

enum IapConfigStatus {
  loading,
  loaded,
  networkError,
  timeout,
  parseError,
}

class IapConfigResult {
  final IapConfig config;
  final IapConfigStatus status;
  final bool fromCache;

  const IapConfigResult({
    required this.config,
    required this.status,
    this.fromCache = false,
  });
}

class IapConfigService {
  static final IapConfigService instance = IapConfigService._();
  IapConfigService._();

  Future<IapConfigResult> fetchConfig() async {
    try {
      final response = await http
          .get(Uri.parse(IapConstants.configUrl))
          .timeout(IapConstants.configTimeout);

      if (response.statusCode != 200) {
        debugPrint('IAP config HTTP ${response.statusCode}');
        return _fallback(IapConfigStatus.networkError);
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      final config = IapConfig.fromJson(json);
      await _cacheConfig(json);
      return IapConfigResult(config: config, status: IapConfigStatus.loaded);
    } on TimeoutException {
      debugPrint('IAP config timeout');
      return _fallback(IapConfigStatus.timeout);
    } on SocketException catch (e) {
      debugPrint('IAP config network error: $e');
      return _fallback(IapConfigStatus.networkError);
    } on http.ClientException catch (e) {
      debugPrint('IAP config client error: $e');
      return _fallback(IapConfigStatus.networkError);
    } on FormatException catch (e) {
      debugPrint('IAP config parse error: $e');
      return _fallback(IapConfigStatus.parseError);
    } catch (e) {
      debugPrint('IAP config unknown error: $e');
      return _fallback(IapConfigStatus.networkError);
    }
  }

  Future<IapConfigResult> _fallback(IapConfigStatus status) async {
    final cached = await _loadCachedConfig();
    if (cached != null) {
      return IapConfigResult(config: cached, status: status, fromCache: true);
    }
    return IapConfigResult(config: IapConfig.offlineFallback(), status: status);
  }

  Future<void> _cacheConfig(Map<String, dynamic> json) async {
    await StorageService.instance.saveString(
      IapConstants.configCacheKey,
      jsonEncode(json),
    );
  }

  Future<IapConfig?> _loadCachedConfig() async {
    final raw = await StorageService.instance.getString(IapConstants.configCacheKey);
    if (raw == null) return null;
    try {
      return IapConfig.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }
}
