//import 'package:appli_ap_sante/pages/home_screen.dart';
import 'package:appli_ap_sante/pages/questionnaire_screen.dart';
import 'package:appli_ap_sante/pages/splash_screen.dart';
import 'package:appli_ap_sante/pages/home_screen.dart';
import 'package:appli_ap_sante/pages/login_page.dart';
import 'package:appli_ap_sante/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart'; // Assure-toi que ce fichier a été généré
import 'package:provider/provider.dart';
import 'package:appli_ap_sante/providers/user_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Mon App',
      initialRoute: '/',
      routes: {
        '/questionnaire': (context) => const QuestionnaireScreen(userId: "nGO44bCJyAwoCDjf8V6P"),
        '/login': (context) => const LoginScreen(),
        '/home': (context) => const HomeScreen(

          userId: "",
        )
        /*'/testpage': (context) => HomeScreen(
          )*/
      },
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
        child: child ?? const SizedBox(),
      ),
      localizationsDelegates: const [
        GlobalCupertinoLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: const [Locale('fr', 'FR')],
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'inter',
        textTheme: ThemeData.dark().textTheme.apply(
          fontFamily: 'inter',
          bodyColor: AppColor.appWhite,
        ),
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          surfaceTintColor: Colors.transparent,
          backgroundColor: AppColor.appBlack,
          foregroundColor: AppColor.appWhite,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          elevation: 0,
        ),
        iconTheme: const IconThemeData(color: AppColor.appWhite),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColor.primaryColor,
            foregroundColor: AppColor.appWhite,
            textStyle: const TextStyle(fontFamily: 'inter', fontWeight: FontWeight.bold, fontSize: 18),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
