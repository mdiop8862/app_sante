import 'package:appli_ap_sante/utils/app_constants.dart';
import 'package:appli_ap_sante/utils/logger.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class UniversityWebLogin extends StatefulWidget {
  const UniversityWebLogin({super.key});
  @override
  State<UniversityWebLogin> createState() => _UniversityWebLoginState();
}

class _UniversityWebLoginState extends State<UniversityWebLogin> {
  final authorizeUrl =
      "https://cas.unilim.fr/oauth2/authorize?response_type=code&scope=openid+profile+email+openid+profile+email+offline_access&client_id=${AppConstants.oidcClientId}&redirect_uri=${AppConstants.oidcRedirectUrl}";
  late WebViewController _controller;
  double loadingPercentage = 0;
  @override
  setState(VoidCallback fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..loadRequest(Uri.parse(authorizeUrl))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() => loadingPercentage = 0);
        },
        onProgress: (progress) {
          setState(() => loadingPercentage = progress.toDouble());
        },
        onPageFinished: (url) {
          setState(() => loadingPercentage = 100);
        },
        onNavigationRequest: (request) {
          AppLogger.d('onNavigationRequest with ${request.url}');
          if (request.url.contains("${AppConstants.oidcRedirectUrl}?")) {
            final parameters = Uri.parse(request.url).queryParameters;
            if (parameters.containsKey('code')) Get.back(result: parameters);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: Get.back,
        ),
      ),
      body: Column(
        children: [
          LinearProgressIndicator(value: loadingPercentage / 100),
          Expanded(child: WebViewWidget(controller: _controller)),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.clearCache();
    _controller.clearLocalStorage();
    super.dispose();
  }
}
