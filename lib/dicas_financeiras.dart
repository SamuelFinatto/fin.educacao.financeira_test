import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'database.dart';

class DicasFinanceiras extends StatefulWidget {
  @override
  _DicasFinanceirasState createState() => _DicasFinanceirasState();
}

class _DicasFinanceirasState extends State<DicasFinanceiras> {
  late List<Map<String, dynamic>> dicasFinanceirasList = [];
  late String documentId;
  late String collectionName = 'dicasfinanceiras'; // Nome da coleção pai
  late PageController _pageController; // Adicionamos um PageController
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _carregarDicasFinanceiras(); // Carregar os conteúdos ao iniciar a tela
    _pageController = PageController(initialPage: _currentIndex); // Inicializamos o PageController com o índice atual
  }

  void _carregarDicasFinanceiras() {
    FirebaseFirestore.instance.collection(collectionName)
        .where('status', isEqualTo: true) // Filtra apenas os documentos com status verdadeiro
        .get()
        .then((snapshot) {
      setState(() {
        dicasFinanceirasList = snapshot.docs.map((doc) => doc.data()).toList();
      });
    });
  }

  Widget _buildCard(Map<String, dynamic> conteudo) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 5), // Adiciona um espaço entre o título e o texto
            Text(
              conteudo['titulo'] ?? 'Sem título',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15), // Adiciona um espaço entre o título e o texto
            Text(
              conteudo['texto'] ?? '',
              style: TextStyle(
                fontSize: 18,
              ),
              textAlign: TextAlign.justify, // Define o alinhamento do texto como justificado
              softWrap: true, // Permite que o texto quebre em várias linhas
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPageView() {
    return PageView.builder(
      itemCount: dicasFinanceirasList.length,
      controller: PageController(initialPage: _currentIndex),
      onPageChanged: (int index) {
        setState(() {
          _currentIndex = index;
        });
      },
      itemBuilder: (BuildContext context, int index) {
        return _buildCard(dicasFinanceirasList[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dicas de Educação Financeira'),
        backgroundColor: Colors.green.shade800,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Aproveite as dicas que preparamos para plenejar seu futuro financeiro no curto, médio e longo prazo!',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.07),
          Container(
            height: MediaQuery.of(context).size.height * 0.58, // Define a altura como 70% da altura da tela
            child: PageView.builder(
              itemCount: dicasFinanceirasList.length,
              controller: _pageController,
              onPageChanged: (int index) {
                setState(() {
                  _currentIndex = index;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return _buildCard(dicasFinanceirasList[index]);
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 75, // Define a altura desejada para a barra
        child: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.arrow_back),
                iconSize: 36, // Define o tamanho do ícone
                onPressed: () {
                  _pageController.previousPage(duration: Duration(milliseconds: 700), curve: Curves.ease);
                },
              ),
              IconButton(
                icon: Icon(Icons.arrow_forward),
                iconSize: 36, // Define o tamanho do ícone
                onPressed: () {
                  _pageController.nextPage(duration: Duration(milliseconds: 700), curve: Curves.ease);
                },
              ),
            ],
          ),
        ),
      ),



    );
  }
}