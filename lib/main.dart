import 'package:flutter/material.dart';
import 'pages/test_page.dart';
import 'pages/profil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'Montserrat',
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Color customRed = const Color(0xFFb01f00);
  final Color customBlack = const Color(0xFFFFFFFF);
  final TextEditingController identifiantController = TextEditingController();
  final TextEditingController motDePasseController = TextEditingController();

  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              SizedBox(height: 50),
              Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/logo.png',
                  height: 140,
                  width: 200,
                ),
              ),
              SizedBox(height: 50),
              Text(
                'Veuillez vous authentifier',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: customBlack,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Container(
                width: 300,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        cursorColor: customRed,
                        controller: identifiantController,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person, color: Colors.white),
                          labelText: "Identifiant",
                          labelStyle: TextStyle(color: Colors.white),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: customRed),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextField(
                        cursorColor: customRed,
                        controller: motDePasseController,
                        style: TextStyle(color: Colors.white),
                        obscureText: true,
                        decoration: InputDecoration(
                          prefixIcon: Icon(Icons.lock, color: Colors.white),
                          labelText: "Mot de passe",
                          labelStyle: TextStyle(color: Colors.white),
                          border: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: customRed),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isChecked = !isChecked;
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(4),
                        color: Colors.white,
                      ),
                      child: isChecked
                          ? Icon(Icons.check, size: 20, color: customRed)
                          : null,
                    ),
                    SizedBox(width: 12),
                    Text(
                      "Vérifier vos dernières connexions",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Container(
                width: 300,
                child: Divider(
                  color: Colors.white,
                  thickness: 0.4,
                  height: 30,
                ),
              ),
              SizedBox(height: 30),
              ElevatedButton(
                onPressed: () {
                  String identifiant = identifiantController.text;
                  String motdepasse = motDePasseController.text;
                  print(identifiant);
                  print(motdepasse);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Profil()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: customRed,
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 30.0),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  elevation: 5,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.login, size: 24, color: Colors.white),
                    SizedBox(width: 7),
                    Text('Se connecter', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(height: 45),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => Profil()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xECFF8542),
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  elevation: 5,
                ),
                child: Text('Identifiant ou mot de passe perdu',
                    style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => TestPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFD14BCDA),
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 32.0),
                  textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  elevation: 5,
                ),
                child: Text('Activer mon compte unilim',
                    style: TextStyle(color: Colors.white)),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
