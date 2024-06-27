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
    await launch(url); // Chama diretamente a função para abrir a URL
  }

  void _carregarIndicacoes() async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('status', isEqualTo: true) // Filtra apenas os documentos com status verdadeiro
          .get();
      setState(() {
        indicacoesList = snapshot.docs.map((doc) {
          var data = doc.data();
          data['categoria'] = data['categoria'] ?? 'Outros'; // Adicione a categoria com valor padrão
          return data;
        }).toList();

        // Ordena a lista de indicações primeiro por categoria e depois por título
        indicacoesList.sort((a, b) {
          int categoriaCompare = a['categoria'].compareTo(b['categoria']);
          if (categoriaCompare == 0) {
            return a['titulo'].compareTo(b['titulo']);
          }
          return categoriaCompare;
        });
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

  void _confirmarAbrirURL(String url, String titulo) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Abrir: $titulo'),
          content: Text('Ao clicar em "OK", você será direcionado para fora do aplicativo.\n\nDeseja continuar?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _launchURL(url);
                Navigator.of(context).pop(); // Fecha o diálogo após abrir a URL
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  List<Widget> _construirListaDeBotoes() {
    Map<String, List<Map<String, dynamic>>> categorias = {};

    for (var conteudo in indicacoesList) {
      String categoria = conteudo['categoria'] ?? 'Outros';
      if (!categorias.containsKey(categoria)) {
        categorias[categoria] = [];
      }
      categorias[categoria]!.add(conteudo);
    }

    List<Widget> widgets = [];

    // Ordenar as categorias alfabeticamente
    var categoriasOrdenadas = categorias.keys.toList()..sort();

    for (var categoria in categoriasOrdenadas) {
      widgets.add(Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: Text(
          categoria,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
      var itens = categorias[categoria]!;
      itens.sort((a, b) => a['titulo'].compareTo(b['titulo']));
      widgets.addAll(itens.map((conteudo) {
        String titulo = conteudo['titulo'] ?? 'Sem título';
        String url = conteudo['url'] ?? '';
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: InkWell(
            onTap: () {
              _confirmarAbrirURL(url, titulo);
            },
            child: Ink(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1000D3), Color(0xFF1A6BFF)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,  // Adjusts size to content
                  children: [
                    Image.asset(
                      'assets/images/internet.png',
                      width: 38,
                      height: 38,
                    ),
                    SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        titulo,
                        style: const TextStyle(
                          fontSize: 17,
                          color: Colors.white,
                        ),
                        softWrap: true, // Allows text wrapping
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );

      }).toList());
    }

    return widgets;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Indicações'),
        backgroundColor: Colors.green.shade800,
      ),
      body: Scrollbar(
        thumbVisibility: true,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Aproveite as indicações para descobrir mais sobre Educação Financeira e ficar atualizado.\n'
                      'Ao clicar em qualquer botão abaixo, você será direcionado para fora do aplicativo!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: _construirListaDeBotoes(),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
