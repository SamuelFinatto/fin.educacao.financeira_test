import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Indicacoes extends StatefulWidget {
  @override
  _IndicacoesState createState() => _IndicacoesState();
}

class _IndicacoesState extends State<Indicacoes> {
  late List<Map<String, dynamic>> indicacoesList = [];
  late String documentId;
  late String collectionName = 'indicacoes'; // Nome da coleção pai

  @override
  void initState() {
    super.initState();
    _carregarIndicacoes(); // Carregar os conteúdos ao iniciar a tela
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir a URL $url';
    }
  }

  void _carregarIndicacoes() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('status', isEqualTo: true) // Filtra apenas os documentos com status verdadeiro
          .get();
      setState(() {
        indicacoesList = snapshot.docs.map((doc) => doc.data()).toList();
      });

      // Verificações adicionadas para depurar
      print('Tamanho da lista de indicações: ${indicacoesList.length}');
      print('Indicações carregadas: $indicacoesList');
      for (var doc in snapshot.docs) {
        print('Conteúdo do documento: ${doc.data()}');
      }
    } catch (e) {
      print('Erro ao carregar indicações: $e');
    }
  }




  List<Widget> _construirListaDeBotoes() {
    return indicacoesList.map((conteudo) {
      String titulo = conteudo['titulo'] ?? 'Sem título';
      String url = conteudo['url'] ?? ''; // Defina uma URL padrão se não houver URL fornecida
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
        child: ElevatedButton(
          onPressed: () {
            _launchURL(url);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF004086),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(
            titulo,
            style: const TextStyle(
              fontSize: 17,
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
        title: Text('Indicações'),
        backgroundColor:
        Colors.green.shade800, // Defina a cor desejada para a barra superior desta tela
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
                'Aproveite as indicações para descobrir mais sobre Educação Financeira e ficar atualizado:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.w400, // Título em negrito
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
