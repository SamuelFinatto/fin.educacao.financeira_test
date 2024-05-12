import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'database.dart';

class Orientador extends StatefulWidget {
  @override
  _OrientadorState createState() => _OrientadorState();
}

class _OrientadorState extends State<Orientador> {
  late List<Map<String, dynamic>> orientadoresList = [];
  late String documentId;
  late String collectionName = 'orientadores'; // Nome da coleção pai

  @override
  void initState() {
    super.initState();
    _carregarOrientadores(); // Carregar os conteúdos ao iniciar a tela
  }

  Future<void> _abrirWhatsApp(String telefone) async {
    String numeroLimpo = telefone.replaceAll(new RegExp(r'[^\w\s]+'), ''); // Remove caracteres não numéricos do número de telefone
    Uri url = Uri.parse('https://wa.me/$numeroLimpo');
    await launchUrl(url);
  }

  void _carregarOrientadores() {
    FirebaseFirestore.instance
        .collection(collectionName)
        .where('status', isEqualTo: true)
        .snapshots()
        .listen((snapshot) {
      setState(() {
        orientadoresList = snapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'nome': doc['nome'],
            'telefone': doc['telefone'], // Certifique-se de que 'telefone' está presente nos documentos
          };
        }).toList();
      });
    });
  }

  void _confirmarAbrirWhatsApp(String telefone) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Abrir o app WhatsApp'),
          content: Text('Ao clicar em "OK", você será direcionado ao aplicativo do WhatsApp.\n\nDeseja continuar?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _abrirWhatsApp(telefone);
                Navigator.of(context).pop(); // Fecha o diálogo após abrir o WhatsApp
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _construirListaDeBotoes() {
    return orientadoresList.map((conteudo) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: ElevatedButton(
          onPressed: () {
            _confirmarAbrirWhatsApp(conteudo['telefone']);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF004086),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: Size(double.infinity, 45),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/whatsapp.png',
                width: 32,
                height: 32,
              ),
              SizedBox(width: 15),
              Flexible(
                child: Text(
                  conteudo['nome'] ?? 'Sem título',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orientador Financeiro'),
        backgroundColor: Colors.green.shade800,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Escolha um orientador e faça contato pelo app Whatsapp clicando em seu nome:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: _construirListaDeBotoes(),
            ),
          ],
        ),
      ),
    );
  }
}
