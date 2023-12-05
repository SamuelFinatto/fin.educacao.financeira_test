import 'package:flutter/material.dart';
import 'database.dart';
import 'juros_compostos.dart';


class Conteudos extends StatefulWidget {
  @override
  _ConteudosState createState() => _ConteudosState();
}

class _ConteudosState extends State<Conteudos> {
  late List<Map<String, dynamic>> conteudosList = [];

  @override
  void initState() {
    super.initState();
    _carregarConteudos(); // Carregar conteúdos ao iniciar o widget
  }

  Future<void> _carregarConteudos() async {
    try {
      var db = Database();
      var telaDeConteudos = await db.buscarDadosDosConteudos();

      setState(() {
        conteudosList = telaDeConteudos.map((row) {
          return {
            'titulo': row['titulo'], // Ajuste conforme a estrutura do retorno da consulta
            'conteudo': row['conteudo'].toString(), // Considerando que 'conteudo' é do tipo TEXT
          };
        }).toList();
      });

      await db.close();
    } catch (e) {
      print('Erro ao conectar ou executar a consulta: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conteúdos - Educação Financeira'),
      ),
      body: ListView.builder(
        itemCount: conteudosList.length,
        itemBuilder: (context, index) {
          final conteudo = conteudosList[index];
          return MyExpansionTile(
            title: conteudo['titulo'],
            content: conteudo['conteudo'],
          );
        },
      ),
    );
  }
}

class MyExpansionTile extends StatefulWidget {
  final String title;
  final String content;

  const MyExpansionTile({
    required this.title,
    required this.content,
  });

  @override
  _MyExpansionTileState createState() => _MyExpansionTileState();
}

class _MyExpansionTileState extends State<MyExpansionTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        widget.title,
        style: TextStyle(
          fontSize: 19, // Tamanho da fonte para o título
          fontWeight: FontWeight.w500, // Peso da fonte, se necessário
          color: Colors.green[900], // Cor do título
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Text(
            widget.content,
            style: TextStyle(
              fontSize: 18, // Tamanho da fonte para o conteúdo
              // Outros estilos de texto, se necessário
            ),
          ),
        ),
      ],
      onExpansionChanged: (isExpanded) {
        setState(() {
          _isExpanded = isExpanded;
        });
      },
    );
  }
}