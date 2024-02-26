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

  // conexão com banco de dados relacional
  // Future<void> _carregarOrientadores() async {
  //   try {
  //     var db = Database();
  //     var telaDeOrientadores = await db.buscarDadosDosOrientadores();
  //
  //     setState(() {
  //       orientadoresList = telaDeOrientadores.map((row) {
  //         return {
  //           'nome': row['nome'], // Ajuste conforme a estrutura do retorno da consulta
  //           'telefone': row['telefone'], // Considerando que 'conteudo' é do tipo TEXT
  //         };
  //       }).toList();
  //     });
  //
  //     await db.close();
  //   } catch (e) {
  //     print('Erro ao conectar ou executar a consulta: $e');
  //   }
  // }

  Future<void> _abrirWhatsApp(String telefone) async {
    Uri url = Uri.parse('https://wa.me/$telefone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Não foi possível abrir o WhatsApp.';
    }
  }

  void _carregarOrientadores() {
    FirebaseFirestore.instance.collection(collectionName)
        .where('status', isEqualTo: true) // Filtra apenas os documentos com status verdadeiro
        .snapshots()
        .listen((snapshot) {
      setState(() {
        orientadoresList = snapshot.docs.map((doc) => doc.data()).toList();
      });
    });
  }

  List<Widget> _construirListaDeBotoes() {
    return orientadoresList.map((conteudo) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
        child: ElevatedButton(
          onPressed: () {
            _abrirWhatsApp(conteudo['telefone']);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Color(0xFF004086), // Cor do texto do botão
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Borda arredondada
            ),
          ),
          child: Text(
            conteudo['nome'] ?? 'Sem título',
            style: const TextStyle(
              fontSize: 17, // Defina o tamanho da fonte desejado
            ),
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
        backgroundColor: Colors.green.shade800 // Defina a cor desejada para a barra superior desta tela
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
                'Escolha um orientador e faça contato pelo Whatsapp clicando em seu nome:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400, // Título em negrito
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
