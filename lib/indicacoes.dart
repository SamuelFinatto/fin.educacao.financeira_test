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
    return indicacoesList.map((conteudo) {
      String titulo = conteudo['titulo'] ?? 'Sem título';
      String url = conteudo['url'] ?? ''; // Defina uma URL padrão se não houver URL fornecida
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
        child: ElevatedButton(
          onPressed: () {
            _confirmarAbrirURL(url, titulo);
          },
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Color(0xFF004086),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            minimumSize: Size(double.infinity, 45), // Define uma altura mínima de 45
            padding: EdgeInsets.all(10), // Adicione algum preenchimento interno para evitar que o texto toque nas bordas
          ),
          child: Row(
            children: [
              Image.asset(
                'assets/images/internet.png', // Caminho para a imagem nos ativos
                width: 38, // Largura desejada para o ícone
                height: 38, // Altura desejada para o ícone
              ),
              SizedBox(width: 10), // Espaçamento entre o ícone e o texto
              Flexible( // Use Flexible para permitir que o Text se ajuste dinamicamente ao espaço disponível
                child: Text(
                  titulo,
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
        title: Text('Indicações'),
        backgroundColor: Colors.green.shade800, // Defina a cor desejada para a barra superior desta tela
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
                'Aproveite as indicações para descobrir mais sobre Educação Financeira e ficar atualizado.\n'
                    'Ao clicar em qualquer botão abaixo, você será direcionado para fora do aplicativo!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400, // Título em negrito
                ),
                textAlign: TextAlign.justify, // Define o alinhamento do texto como justificado
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
    );
  }
}
