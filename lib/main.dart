import 'package:flutter/material.dart';
import 'login_page.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Inicialize o Firebase antes de executar o app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Verifica o estado de inicialização do Firebase
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          // Se o Firebase foi inicializado com sucesso, vá para a página de login
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: LoginPage(),
          );
        } else if (snapshot.hasError) {
          // Se houver erro na inicialização, mostre uma mensagem de erro
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: Text('Erro na inicialização do Firebase: ${snapshot.error}'),
              ),
            ),
          );
        } else {
          // Enquanto o Firebase está sendo inicializado, mostre um indicador de carregamento
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }
      },
    );
  }
}