import 'package:appli_ap_sante/pages/university_web_login.dart';
import 'package:appli_ap_sante/utils/app_constants.dart';
import 'package:appli_ap_sante/utils/logger.dart';
import 'package:get/get.dart';
import 'package:openid_client/openid_client_io.dart';

class OpenidClientService {
  static Future<UserInfo?> getUserInfoFromToken(Map<String, dynamic> tokenResponse) async {
    try {
      // create the client
      final customUrl = Uri.parse(AppConstants.oidcDiscoveryUrl);
      final issuer = await Issuer.discover(customUrl);
      // issuer.metadata.user
      final client = Client(issuer, AppConstants.oidcClientId);

      final c = Credential.fromJson({
        'issuer': issuer.metadata.toJson(),
        'client_id': client.clientId,
        'client_secret': client.clientSecret,
        'token': tokenResponse
      });
      // return the user info
      return await c.getUserInfo();
    } catch (e, s) {
      AppLogger.e('Error', stackTrace: s, error: e, functionName: 'OpenidClientService.getUserInfoFromToken');
      return null;
    }
  }

  Future<String?> getAuthorizationCodeFromWebLogin() async {
    final res = await Get.to(() => const UniversityWebLogin());
    AppLogger.d('return with $res');
    return res?['code']?.toString();
  }
}
