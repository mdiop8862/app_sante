import 'package:appli_ap_sante/pages/home_screen.dart';
import 'package:appli_ap_sante/providers/user_provider.dart';
import 'package:appli_ap_sante/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: Consumer<UserProvider>(
          builder: (context, userProvider, _) {
            if (userProvider.isLoading) {
              return const CircularProgressIndicator();
            }
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/university.png',
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                const SizedBox(height: 30),
                if (userProvider.error != null)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      userProvider.error ?? '',
                      style: const TextStyle(color: AppColor.primaryColor),
                    ),
                  ),
                ElevatedButton(
                  onPressed: () async {
                    final success = await userProvider.login();
                    if (success) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomeScreen(
                            userId: userProvider.email ?? '',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Se connecter avec Unilim'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
