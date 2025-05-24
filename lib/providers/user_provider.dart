import 'package:appli_ap_sante/services/openid_client_service.dart';
import 'package:appli_ap_sante/utils/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:appli_ap_sante/services/flutter_auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider extends ChangeNotifier {
  final _authService = FlutterAuthService();
  bool _isLoggedIn = false;
  bool _isLoading = false;
  String? _error;

  bool get isLoggedIn => _isLoggedIn;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? nom;
  String? prenom;
  String? email;



  Future<bool> login() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final code =
          await OpenidClientService().getAuthorizationCodeFromWebLogin();
      if (code == null) throw Exception('Authorization code is null');
      final token = await FlutterAuthService().getAccessToken(code);
      if (token == null) throw Exception('Token is null');
      final userInfo = await OpenidClientService.getUserInfoFromToken(token);
      AppLogger.d('user info: ${userInfo?.toJson()}');
      if (userInfo == null) throw Exception('User info is null');
      prenom = userInfo.givenName ?? '';
      nom = userInfo.name ?? userInfo.familyName ?? '';
      email = userInfo.email ?? '';

      //  Enregistrement dans Firestore
      final usersRef = FirebaseFirestore.instance.collection('users');
      await usersRef.doc(email).set({
        'prenom': prenom,
        'nom': nom,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
      _isLoggedIn = true;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoggedIn = false;
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    _isLoggedIn = false;
    notifyListeners();
  }
}
