import 'database.dart';
import 'home_page.dart'; // Importe a classe HomePage
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    home: MyApp(),
  ));

  ;
}

class MyApp extends StatelessWidget {

  String userName = ""; // Declare a variável userName
  String email = ""; // Declare a variável userName

  Future<void> _navigateToHomePage(BuildContext context) async {
    final User? user = await _signInWithGoogle();
    if (user != null) {
      userName = user.displayName ?? "Usuário Anônimo"; // Use displayName ou "Usuário Anônimo" se for nulo
      email = user.email ?? "sem email";

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => HomePage(userName, email, _signOut), // Passe o nome do usuário para a HomePage
        ),
      );

    } else {
      // Trate erro de autenticação.
    }
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      User? user = userCredential.user;
      if (user != null) {
        userName = "Usuário Anônimo"; // Use displayName ou "Usuário Anônimo" se for nulo
        email = "sem email";

        try {
          var db = Database();
          //await db.connect();
          var telaDeConteudos = await db.buscarDadosDosConteudos();

          for (var row in telaDeConteudos) {
            print('ID: ${row['id']}');
            print('idOrientador: ${row['idOrientador']}');
            // Adicione outras manipulações de dados conforme necessário
          }
          //print(data);
          await db.close();
        } catch (e) {
          print('Erro ao conectar ou executar a consulta: $e');
        } finally {
        }

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => HomePage(userName, email, _signOut), // Passe o nome do usuário para a HomePage
          ),
        );
      }
    } catch (error) {
      print("Erro durante o login anônimo: $error");
      // Trate o erro de autenticação, se necessário
    }
  }

  Future<void> _signOut(BuildContext context) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        // Verifica se o usuário está autenticado com o provedor do Google
        if (currentUser.providerData.any((userInfo) => userInfo.providerId == 'google.com')) {
          // Caso o usuário esteja autenticado com o Google, faz o logout
          await GoogleSignIn().signOut();
        }
        // Realiza o logout do usuário atual no Firebase
        await FirebaseAuth.instance.signOut();
        print("Usuário desconectado com sucesso.");

        // Redireciona o usuário de volta para a página de login
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => MyApp()),
              (Route<dynamic> route) => false,
        );
      } else {
        print("Nenhum usuário autenticado.");
      }
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
          title: Text('MoneySense - Login'),
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
              ElevatedButton(
                onPressed: () {
                  _signInAnonymously(context); // Chama o login anônimo
                },
                child: Text('Login Anônimo'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}