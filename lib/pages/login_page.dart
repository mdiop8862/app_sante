import 'package:appli_ap_sante/pages/formulaire_imc.dart';
import 'package:appli_ap_sante/pages/home_page.dart';
import 'package:appli_ap_sante/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool showPassword = true, isChecked = false;
  @override
  Widget build(BuildContext context) {
    const defaultBorder = UnderlineInputBorder(borderSide: BorderSide(color: Colors.white));
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/images/university.png', width: Get.width / 2),
              const SizedBox(height: 70),
              const Text(
                'Veuillez vous authentifier',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 50),
              ...[
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset('assets/images/person_icon.png', height: 40, width: 40, fit: BoxFit.cover),
                    const SizedBox(width: 15),
                    const Expanded(
                      child: TextField(
                        cursorColor: AppColor.appWhite,
                        decoration: InputDecoration(
                          labelText: 'Identifiant',
                          border: defaultBorder,
                          enabledBorder: defaultBorder,
                          focusedBorder: defaultBorder,
                          focusColor: AppColor.appWhite,
                          labelStyle:
                              TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Image.asset('assets/images/password_icon.png', height: 40, width: 40, fit: BoxFit.cover),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        obscureText: showPassword,
                        cursorColor: AppColor.appWhite,
                        decoration: InputDecoration(
                          labelText: 'Mot de passe',
                          border: defaultBorder,
                          enabledBorder: defaultBorder,
                          focusedBorder: defaultBorder,
                          focusColor: AppColor.appWhite,
                          labelStyle:
                              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => showPassword = !showPassword),
                            icon: Icon(
                              showPassword ? Icons.visibility : Icons.visibility_off,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      height: 40,
                      width: 40,
                      child: Checkbox(
                        value: isChecked,
                        activeColor: AppColor.primaryColor,
                        onChanged: (value) => setState(() => isChecked = value ?? false),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: TextField(
                        onTap: () => setState(() => isChecked = !isChecked),
                        readOnly: true,
                        obscureText: showPassword,
                        cursorColor: AppColor.appWhite,
                        decoration: const InputDecoration(
                          hintText: 'Voir mes dernières connexions',
                          border: defaultBorder,
                          enabledBorder: defaultBorder,
                          focusedBorder: defaultBorder,
                          disabledBorder: defaultBorder,
                          focusColor: AppColor.appWhite,
                          hintStyle:
                              TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    )
                  ],
                )
              ].map((e) => Padding(padding: const EdgeInsets.symmetric(horizontal: 20), child: e)),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () => Get.offAll(() => const FormulaireImc()),
                style: ElevatedButton.styleFrom(fixedSize: Size(MediaQuery.sizeOf(context).width * .7, 40)),
                child: const Text('Se connecter'),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.sizeOf(context).width * .9, 40),
                  foregroundColor: AppColor.appBlack,
                  backgroundColor: const Color(0xFFCCFF00),
                ),
                child: const Text('Identifiant ou mot de passe perdu ?'),
              ),
              const SizedBox(height: 25),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(MediaQuery.sizeOf(context).width * .9, 40),
                  foregroundColor: AppColor.appBlack,
                  backgroundColor: const Color(0xFF0FE7FF),
                ),
                child: const Text('Activer mon compte unilim'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
