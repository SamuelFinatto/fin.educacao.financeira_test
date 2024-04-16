import 'package:flutter/material.dart';
import 'home_page.dart'; // Importe a classe HomePage
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LoginBody(),
      ),
    );
  }
}

class LoginBody extends StatelessWidget {
  String userName = "";
  String email = "";

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
          MaterialPageRoute(builder: (context) => LoginPage()),
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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF08005E), // Cor inicial do gradiente
              Color(0xFF004FFF), // Cor final do gradiente
            ],
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 150,
              left: 0,
              right: 0,
              child: Container(
                alignment: Alignment.center,
                height: 200, // Defina a altura desejada para a imagem
                child: Image.asset(
                  'assets/images/logo_fin.png', // Insira o caminho para a sua imagem
                  fit: BoxFit.contain, // Ajuste para o tipo de redimensionamento desejado
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: 300), // Adiciona um espaço acima dos botões
                  SizedBox(
                    width: 280, // Defina a largura desejada
                    height: 48, // Defina a altura desejada
                    child: Material(
                      borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                      color: Colors.transparent, // Torna o Material transparente para permitir o gradiente de fundo
                      child: InkWell(
                        borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                        onTap: () async {
                          _navigateToHomePage(context); // Navega para a HomePage
                        },
                        splashColor: Colors.white.withOpacity(0.5), // Define a cor do efeito de toque
                        highlightColor: Colors.transparent, // Define a cor de destaque como transparente para remover a cor padrão
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF080075), Color(0xFF0045CC)], // Cores do gradiente
                              begin: Alignment.centerLeft, // Início do gradiente à esquerda
                              end: Alignment.centerRight, // Fim do gradiente à direita
                            ),
                            borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4), // Cor da sombra
                                spreadRadius: 2, // Espalhamento da sombra
                                blurRadius: 5, // Desfoque da sombra
                                offset: Offset(0, 0), // Deslocamento da sombra
                              ),
                            ],
                          ),
                          child: Material( // Adicione um Material dentro do InkWell para exibir o efeito de toque
                            type: MaterialType.transparency, // Torna o Material transparente
                            borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                            child: InkWell( // Adicione um novo InkWell para exibir o efeito de toque
                              onTap: () async {
                                _navigateToHomePage(context); // Navega para a HomePage
                              },
                              borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25), // Adicione um padding horizontal
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/google_com_fundo.png', // Insira o caminho para a sua imagem
                                      width: 35, // Defina a largura da imagem
                                      height: 35, // Defina a altura da imagem
                                    ),
                                    const SizedBox(width: 16), // Adiciona um espaço entre a imagem e o texto
                                    Expanded(
                                      child: const Text(
                                        'Login com Google',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white, // Define a cor do texto como branco
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),


                  SizedBox(height: 25), // Adiciona um espaço entre os botões

                  SizedBox(
                    width: 280, // Defina a largura desejada
                    height: 48, // Defina a altura desejada
                    child: Material(
                      borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                      color: Colors.transparent, // Torna o Material transparente para permitir o gradiente de fundo
                      child: InkWell(
                        borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                        onTap: () async {
                          _signInAnonymously(context); // Navega para a HomePage
                        },
                        splashColor: Colors.white.withOpacity(0.5), // Define a cor do efeito de toque
                        highlightColor: Colors.transparent, // Define a cor de destaque como transparente para remover a cor padrão
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Color(0xFF080075), Color(0xFF0045CC)], // Cores do gradiente
                              begin: Alignment.centerLeft, // Início do gradiente à esquerda
                              end: Alignment.centerRight, // Fim do gradiente à direita
                            ),
                            borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.4), // Cor da sombra
                                spreadRadius: 2, // Espalhamento da sombra
                                blurRadius: 5, // Desfoque da sombra
                                offset: Offset(0, 0), // Deslocamento da sombra
                              ),
                            ],
                          ),
                          child: Material( // Adicione um Material dentro do InkWell para exibir o efeito de toque
                            type: MaterialType.transparency, // Torna o Material transparente
                            borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                            child: InkWell( // Adicione um novo InkWell para exibir o efeito de toque
                              onTap: () async {
                                _signInAnonymously(context); // Navega para a HomePage
                              },
                              borderRadius: BorderRadius.circular(17), // Define o raio dos cantos
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25), // Adicione um padding horizontal
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Image.asset(
                                      'assets/images/anonimo_branco_maior_na_esquerda.png', // Insira o caminho para a sua imagem
                                      width: 36, // Defina a largura da imagem
                                      height: 36, // Defina a altura da imagem
                                    ),
                                    const SizedBox(width: 16), // Adiciona um espaço entre a imagem e o texto
                                    Expanded(
                                      child: const Text(
                                        'Login Anônimo',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.white, // Define a cor do texto como branco
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}