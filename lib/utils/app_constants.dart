class AppConstants {
  static const String oidcDiscoveryUrl = 'https://cas.unilim.fr/.well-known/openid-configuration';
  static const String oidcRedirectUrl = 'com.example.appli_ap_sante:/oauthredirect';
  static const String oidcClientId = 'ap-sante';
  static const List<String> oidcScopes = ['openid', 'profile', 'email', 'offline_access'];
}
