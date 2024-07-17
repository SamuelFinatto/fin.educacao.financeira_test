import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'login_page.dart';

class Configuracoes extends StatefulWidget {
  final String userEmail;
  final Function(BuildContext) onSignOut; // Função para realizar o sign out

  Configuracoes(this.onSignOut, {required this.userEmail});

  @override
  _ConfiguracoesState createState() => _ConfiguracoesState();
}

class _ConfiguracoesState extends State<Configuracoes> {
  bool _isPolicyAccepted = true;
  DateTime lastUpdateDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _fetchUserPrivacyData();
  }

  Future<void> _fetchUserPrivacyData() async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('politicadeprivacidade')
          .where('email', isEqualTo: widget.userEmail)
          .where('aceite', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot userDoc = querySnapshot.docs.first;
        setState(() {
          lastUpdateDate = (userDoc.get('dataultimaalteracao') as Timestamp).toDate();
          _isPolicyAccepted = userDoc.get('aceite') as bool;  // Assuming 'aceite' is a boolean field
        });
      }
    } catch (e) {
      print("Erro ao buscar dados da política de privacidade: $e");
    }
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

  // Função para abrir URLs
  _launchURL(String url) async {
    await launch(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações da conta'),
        backgroundColor: Colors.green.shade800,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            FutureBuilder<Widget>(
              future: _buildPolicyToggle(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return snapshot.data ?? SizedBox.shrink();
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 30),
            _buildLastUpdateInfo(),
            _buildEmailInfo(),
          ],
        ),
      ),
    );
  }


  Future<Widget> _buildPolicyToggle() async {
    String url = await _fetchPrivacyPolicyUrl();  // Busca a URL da política de privacidade
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Aceite da Política de Privacidade',
            style: TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8), // Espaço entre o título e o texto
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(color: Colors.black, fontSize: 16),
                    children: [
                      TextSpan(text: 'Mantenha ativado se concorda com a '),
                      TextSpan(
                        text: 'política de privacidade',
                        style: TextStyle(
                          color: Colors.blue,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {
                          _launchURL(url); // Substitua pelo link real da sua política
                        },
                      ),
                      TextSpan(text: '. Caso revogue o aceite, seu perfil será removido por questões de segurança.'),
                    ],
                  ),
                ),
              ),
              Transform.scale(
                scale: 1.3,
                child: Switch(
                  value: _isPolicyAccepted,
                  onChanged: _updatePrivacyPolicyAcceptance,
                  activeColor: Colors.green,
                  inactiveThumbColor: Colors.red,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _updatePrivacyPolicyAcceptance(bool accepted) {
    if (!accepted) {
      // Mostra um diálogo de confirmação antes de proceder
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Revogar seu aceite"),
            content: Text("Tem certeza que deseja revogar o aceite e excluir seu perfil?"),
            actions: <Widget>[
              TextButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Confirmar exclusão'),
                onPressed: () async {
                  Navigator.of(context).pop();  // Fecha o diálogo primeiro

                  setState(() {
                    _isPolicyAccepted = false;
                  });

                  // Remove documentos relacionados ao usuário e atualiza o campo 'aceite'
                  await _processUserDeletion();

                  // Faz logout
                  await _signOut();

                  // Redireciona para a tela de login
                  _redirectToLogin();
                },
              ),
            ],
          );
        },
      );
    } else {
      setState(() {
        _isPolicyAccepted = accepted;
      });
      _updatePrivacyPolicyField(accepted);
    }
  }

  Future<void> _processUserDeletion() async {
    try {
      // Remove documentos relacionados ao usuário
      await _removeUserDocuments();

      // Atualiza o campo 'aceite' para false
      bool updateSuccess = await _updatePrivacyPolicyField(false);
      if (!updateSuccess) {
        throw Exception("Falha ao atualizar o campo 'aceite'.");
      }
    } catch (e) {
      print("Erro ao processar a exclusão do usuário: $e");
    }
  }

  Future<bool> _updatePrivacyPolicyField(bool accepted) async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('politicadeprivacidade')
        .where('email', isEqualTo: widget.userEmail)
        .where('aceite', isEqualTo: true)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      String docId = querySnapshot.docs.first.id;

      // Atualiza o campo 'aceite' e 'dataultimaalteracao'
      await FirebaseFirestore.instance
          .collection('politicadeprivacidade')
          .doc(docId)
          .update({
        'aceite': accepted,
        'dataultimaalteracao': FieldValue.serverTimestamp() // Atualiza a data e hora para o momento atual do servidor
      });
      return true; // Retorna sucesso
    } else {
      print("Nenhum documento encontrado com o e-mail especificado.");
      return false; // Retorna falha
    }
  }

  Future<void> _removeUserDocuments() async {
    List<String> collections = ['metas', 'investimentos'];
    for (var collection in collections) {
      try {
        var querySnapshot = await FirebaseFirestore.instance
            .collection(collection)
            .where('email', isEqualTo: widget.userEmail)
            .get();

        // Verifica se documentos foram encontrados
        if (querySnapshot.docs.isEmpty) {
          print("Nenhum documento encontrado em $collection para o e-mail ${widget.userEmail}.");
        } else {
          for (var doc in querySnapshot.docs) {
            try {
              await FirebaseFirestore.instance
                  .collection(collection)
                  .doc(doc.id)
                  .delete();
              print("Documento ${doc.id} removido com sucesso de $collection.");
            } catch (e) {
              print("Erro ao remover documento ${doc.id} de $collection: $e");
            }
          }
        }
      } catch (e) {
        print("Erro ao acessar documentos da coleção $collection: $e");
      }
    }
  }

  Widget _buildLastUpdateInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 0),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Última alteração: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: DateFormat('dd/MM/yyyy HH:mm').format(lastUpdateDate),
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmailInfo() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
      child: RichText(
        text: TextSpan(
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
          children: <TextSpan>[
            TextSpan(
              text: 'Usuário: ',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextSpan(
              text: widget.userEmail,
              style: TextStyle(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _signOut() async {
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
        _redirectToLogin();
      } else {
        print("Nenhum usuário autenticado.");
      }
    } catch (error) {
      print("Erro durante o logout: $error");
    }
  }

  void _redirectToLogin() {
    print("Redirecionando para a tela de login...");
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginPage()),
            (Route<dynamic> route) => false,
      );
  }
}
