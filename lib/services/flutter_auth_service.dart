import 'package:appli_ap_sante/utils/app_constants.dart';
import 'package:appli_ap_sante/utils/logger.dart';
import 'package:appli_ap_sante/utils/pref_util.dart';
import 'package:flutter_appauth/flutter_appauth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class FlutterAuthService {
  static final FlutterAuthService _instance = FlutterAuthService._internal();
  factory FlutterAuthService() => _instance;
  FlutterAuthService._internal();

  static const _appAuth = FlutterAppAuth();
  static const _secureStorage = FlutterSecureStorage();
  Future<bool> login() async {
    try {
      // Create an authorization request with PKCE
      final result = await _appAuth.authorizeAndExchangeCode(
        AuthorizationTokenRequest(
          AppConstants.oidcClientId,
          AppConstants.oidcRedirectUrl,
          discoveryUrl: AppConstants.oidcDiscoveryUrl,
          scopes: AppConstants.oidcScopes,
        ),
      );

      if (result != null) {
        // Store tokens securely
        await _secureStorage.write(key: PrefKey.accessToken.name, value: result.accessToken);
        await _secureStorage.write(key: PrefKey.refreshToken.name, value: result.refreshToken);
        await _secureStorage.write(key: PrefKey.idToken.name, value: result.idToken);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>?> getAccessToken(String code) async {
    final result = await _appAuth.token(TokenRequest(
      AppConstants.oidcClientId,
      AppConstants.oidcRedirectUrl,
      authorizationCode: code,
      discoveryUrl: AppConstants.oidcDiscoveryUrl,
    ));
    AppLogger.d('Access token: ${result?.accessToken}');
    AppLogger.d('Refresh token: ${result?.refreshToken}');
    AppLogger.d('ID token: ${result?.idToken}');
    return result == null
        ? null
        : {
      'access_token': result.accessToken,
      'refresh_token': result.refreshToken,
      'id_token': result.idToken,
    };
  }

  Future<bool> logout() async {
    try {
      await _secureStorage.delete(key: PrefKey.accessToken.name);
      await _secureStorage.delete(key: PrefKey.refreshToken.name);
      await _secureStorage.delete(key: PrefKey.idToken.name);
      return true;
    } catch (e, s) {
      AppLogger.e(
        'Error',
        stackTrace: s,
        error: e,
        functionName: 'AuthService.logout',
      );
      return false;
    }
  }
}
