import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
    _pageController = PageController(
        initialPage:
            _currentIndex); // Inicializamos o PageController com o índice atual
  }

  void _carregarDicasFinanceiras() {
    FirebaseFirestore.instance
        .collection(collectionName)
        .where('status',
            isEqualTo:
                true) // Filtra apenas os documentos com status verdadeiro
        .get()
        .then((snapshot) {
      setState(() {
        dicasFinanceirasList = snapshot.docs.map((doc) => doc.data()).toList();
      });
    });
  }

  Widget _buildCard(Map<String, dynamic> conteudo) {
    final _scrollController = ScrollController();
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(7.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 5),
            Text(
              conteudo['titulo'] ?? 'Sem título',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 15),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: EdgeInsets.only(right: 8),
                    // Adiciona uma margem de 4 pixels à direita da barra de rolagem
                    child: Column(
                      children: [
                        Text(
                          conteudo['texto'] ?? '',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.justify,
                          softWrap: true,
                        ),
                        //SizedBox(height: 36), // Espaçamento adicional para mostrar a seta de rolagem para baixo
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dicas Financeiras'),
        backgroundColor: Colors.green.shade800,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                Navigator.pop(context); // Volta para a tela anterior
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15.0),
            child: Text(
              "Aproveite as dicas que preparamos para planejar seu futuro financeiro no curto, médio e longo prazo.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w400,
              ),
              textAlign: TextAlign
                  .justify, // Define o alinhamento do texto como justificado
            ),
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
          Container(
            height: MediaQuery.of(context).size.height * 0.54, // Define a altura como 70% da altura da tela
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
      drawer: Drawer(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 120, // Define a altura desejada para o DrawerHeader
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color:
                      Colors.green.shade800, // Define a cor de fundo como verde
                ),
                child: Center(
                  child: Text(
                    'Dicas Financeiras',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white, // Define a cor do texto como branco
                    ),
                  ),
                ),
              ),
            ),
            // Espaço entre os botões
            Expanded(
              child: Scrollbar(
                thumbVisibility: false, // Torna a barra de rolagem visível
                child: ListView.builder(
                  padding: EdgeInsets.zero, // Remove padding padrão da ListView
                  itemCount: dicasFinanceirasList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 0.0),
                      // Ajusta o padding superior/inferior
                      child: ListTile(
                        title: Text(
                          '${index + 1}. ${dicasFinanceirasList[index]['titulo']}',
                          style: TextStyle(
                            fontSize: 16, // Define o tamanho da fonte
                          ),
                        ),
                        onTap: () {
                          _pageController.jumpToPage(
                            index,
                          ); // Navegue para a página correspondente
                          Navigator.pop(context); // Feche o Drawer
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
        bottomNavigationBar: Container(
          height: 90, // Define a altura desejada para a barra
          child: BottomAppBar(
            elevation: 0, // Remove a sombra do BottomAppBar
            color: Theme.of(context).scaffoldBackgroundColor, // Usa a cor de fundo da tela principal
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back_ios),
                  iconSize: 45, // Define o tamanho do ícone
                  onPressed: () {
                    if (_currentIndex > 0) {
                      _pageController.previousPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease
                      );
                    } else {
                      _pageController.animateToPage(
                          dicasFinanceirasList.length - 1,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease
                      );
                    }
                  },
                ),
                Text(
                  dicasFinanceirasList.isNotEmpty
                      ? "${(_currentIndex % dicasFinanceirasList.length) + 1} / ${dicasFinanceirasList.length}"
                      : "0 / 0", // Mostra 0/0 se a lista estiver vazia
                  style: TextStyle(fontSize: 20), // Estilo do texto do contador
                ),
                IconButton(
                  icon: Icon(Icons.arrow_forward_ios),
                  iconSize: 45, // Define o tamanho do ícone
                  onPressed: () {
                    if (_currentIndex < dicasFinanceirasList.length - 1) {
                      _pageController.nextPage(
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease
                      );
                    } else {
                      _pageController.animateToPage(
                          0,
                          duration: Duration(milliseconds: 500),
                          curve: Curves.ease
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        )

    );
  }
}
