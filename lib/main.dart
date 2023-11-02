import 'home_page.dart'; // Importe a classe HomePage
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {

  String userName = ""; // Declare a variável userName

  Future<void> _navigateToHomePage(BuildContext context) async {
    final User? user = await _signInWithGoogle();
    if (user != null) {
      userName = user.displayName ?? "Usuário Anônimo"; // Use displayName ou "Usuário Anônimo" se for nulo
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomePage(userName, _signOut), // Passe o nome do usuário para a HomePage
        ),
      );
    } else {
      // Trate erro de autenticação.
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      await GoogleSignIn().signOut();
      print("Usuário desconectado com sucesso.");
      // Após o logout, redirecione o usuário de volta para a página de login
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => MyApp(), // Redirecione para a página de login
        ),
      );
    } catch (error) {
      print("Erro durante o logout: $error");
    }
  }


  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = authResult.user;

      return user;
    } catch (error) {
      print("Erro durante o login com o Google: $error");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Login com Google'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () {
                  _navigateToHomePage(context); // Navega para a HomePage
                },
                child: Text('Login com Google'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}