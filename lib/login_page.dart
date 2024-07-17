import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'home_page.dart'; // Importe a classe HomePage
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

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
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Erro de conexão!"),
          content: SingleChildScrollView( // Use SingleChildScrollView para evitar overflow
            child: ListBody( // Use ListBody para compor múltiplos widgets verticalmente
              children: <Widget>[
                Row( // Usa Row para adicionar ícone ao lado do texto
                  children: <Widget>[
                    Icon(Icons.signal_wifi_off, color: Colors.red), // Ícone de "sem sinal"
                    SizedBox(width: 10), // Espaço entre ícone e texto
                    Expanded( // Expanded para preencher o espaço horizontal restante
                      child: Text(
                        "Nenhuma conexão com a internet detectada. Conecte-se à internet para entrar no aplicativo Fin.",
                        textAlign: TextAlign.justify, // Justifica o texto
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
      return;
    }

    final User? user = await _signInWithGoogle();
    String url = await _fetchPrivacyPolicyUrl();  // Busca a URL da política de privacidade
    if (user != null) {
      print(user.email);
      // Verifica se o usuário aceitou a política de privacidade
      if (await _hasAcceptedPrivacyPolicy(user.email)) {
        // Continua para a HomePage se aceitou a política
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => HomePage(user.displayName ?? "Usuário Anônimo", user.email ?? "login sem email", _signOut),
        ));
      }else {
        // Mostra um aviso se não aceitou a política
        showDialog(
          context: context,
          barrierDismissible: false,  // Impede que o diálogo seja fechado sem uma ação explícita
          builder: (context) => AlertDialog(
            title: Text("Política de Privacidade"),
            content: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyText1, // Estilo do texto padrão
                children: [
                  TextSpan(
                    text: "Você deve aceitar a ",
                    style: TextStyle(fontSize: 15), // Ajusta o tamanho da fonte para 18
                  ),
                  TextSpan(
                    text: 'política de privacidade',
                    style: TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                      fontSize: 15, // Ajusta o tamanho da fonte para 18
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      _launchURL(url); // Substitua pelo link real da sua política
                    },
                  ),
                  TextSpan(
                    text: " para usar o aplicativo Fin.\n\n"
                        "Caso queira revogar seu aceite no futuro, você poderá fazer isso a qualquer momento através do menu lateral esquerdo, em Configurações da conta.\n\n"
                        "Caso não aceite, você apenas poderá utilizar o Fin como anônimo(a).",
                    style: TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
              actions: <Widget>[
                TextButton(
                  child: Text(
                    'Não aceitar',
                    style: TextStyle(fontSize: 16),  // Ajusta o tamanho da fonte para 18
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();  // Fecha o diálogo
                    _signOut(context);  // Chama a função para fazer logout
                  },
                ),
              TextButton(
                child: Text(
                  'Aceitar e Entrar',
                  style: TextStyle(fontSize: 16),  // Ajusta o tamanho da fonte para 18),
                ),
                onPressed: () async {
                  // Salva a aceitação no Firestore
                  await FirebaseFirestore.instance.collection('politicadeprivacidade').add({
                    'email': user.email,  // Assuma que 'email' é uma variável disponível que contém o e-mail do usuário
                    'aceite': true,
                    'dataultimaalteracao': DateTime.now(),  // Registra a data e hora do aceite
                  });
                  Navigator.of(context).pop();  // Fecha o diálogo após salvar
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => HomePage(user.displayName ?? "Usuário Anônimo", user.email ?? "login sem email", _signOut),
                  ));
                },
              ),
            ],
          ),
        );
      }

    } else {
      // Trate o erro de autenticação, se necessário
    }
  }

  // Função para abrir URLs
  _launchURL(String url) async {
    await launch(url);
  }

  Future<String> _fetchPrivacyPolicyUrl() async {
    try {
      // Busca o documento único na coleção 'urlpoliticadeprivacidade'
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('urlpoliticadeprivacidade')
          .doc('UovFeUKrFWLnmQeXwFEr')  // Substitua 'uniqueDocumentId' pelo ID real do documento se necessário
          .get();

      if (documentSnapshot.exists) {
        return documentSnapshot.get('url');  // Pega a URL da política de privacidade
      } else {
        throw Exception("Documento de URL da política de privacidade não encontrado.");
      }
    } catch (e) {
      print("Erro ao buscar URL da política de privacidade: $e");
      rethrow;  // Relança a exceção para ser tratada onde a função é chamada
    }
  }

  Future<bool> _hasAcceptedPrivacyPolicy(String? email) async {
    if (email == null) {
      print("E-mail is null");
      return false;
    }
    try {
      // Consulta a coleção para encontrar documentos onde o campo 'email' corresponde ao e-mail do usuário e 'aceite' é true
      final querySnapshot = await FirebaseFirestore.instance
          .collection('politicadeprivacidade')
          .where('email', isEqualTo: email)
          .where('aceite', isEqualTo: true)
          .get();

      // Verifica se algum documento foi retornado
      if (querySnapshot.docs.isNotEmpty) {
        print("Privacy policy accepted");
        return true;
      } else {
        print("No document found or privacy policy not accepted");
        return false;
      }
    } catch (e) {
      print("Error checking privacy policy: $e");
      return false;
    }
  }


  Future<User?> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) return null;
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final UserCredential authResult = await FirebaseAuth.instance.signInWithCredential(credential);
      return authResult.user;
    } catch (error) {
      print("Erro durante o login com o Google: $error");
      return null;
    }
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      var connectivityResult = await Connectivity().checkConnectivity();
      if (connectivityResult == ConnectivityResult.none) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("Erro de conexão!"),
            content: SingleChildScrollView( // Use SingleChildScrollView para evitar overflow
              child: ListBody( // Use ListBody para compor múltiplos widgets verticalmente
                children: <Widget>[
                  Row( // Usa Row para adicionar ícone ao lado do texto
                    children: <Widget>[
                      Icon(Icons.signal_wifi_off, color: Colors.red), // Ícone de "sem sinal"
                      SizedBox(width: 10), // Espaço entre ícone e texto
                      Expanded( // Expanded para preencher o espaço horizontal restante
                        child: Text(
                          "Nenhuma conexão com a internet detectada. Conecte-se à internet para  entrar no aplicativo Fin.",
                          textAlign: TextAlign.justify, // Justifica o texto
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
        );
        return;
      }

      UserCredential userCredential = await FirebaseAuth.instance.signInAnonymously();
      User? user = userCredential.user;
      if (user != null) {
        userName = "usuário Anônimo"; // Use displayName ou "Usuário Anônimo" se for nulo
        email = "Login sem email";

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
                    width: 330, // Defina a largura desejada
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
                                        'Entrar com o Google',
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
                    width: 330, // Defina a largura desejada
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
                                        'Entrar como anônimo(a)',
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