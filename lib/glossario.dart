import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Glossario extends StatefulWidget {
  @override
  _GlossariosState createState() => _GlossariosState();
}

class _GlossariosState extends State<Glossario> {
  late String documentId;
  late String collectionName = 'glossario'; // Nome da coleção pai
  ScrollController _scrollController = ScrollController(); // ScrollController para controlar a rolagem

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glossário'),
        backgroundColor: Colors.green.shade800,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () => _showInfoDialog(context),
            ),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(collectionName).orderBy('titulo').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro ao carregar os dados: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            controller: _scrollController,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = snapshot.data!.docs[index];
              documentId = document.id;
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: MyExpansionTile(
                  title: "${index + 1}. ${data['titulo']}",
                  content: data['texto'],
                  documentId: documentId,
                  index: index,
                  totalItems: snapshot.data!.docs.length,
                  scrollController: _scrollController,
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Explicando a tela Glossário:"),
          content: SizedBox(
            height: MediaQuery.of(context).size.height * 0.25,
            child: Scrollbar(
              thumbVisibility: true,
              child: SingleChildScrollView(
                child: Text(
                  "Esta tela é destinada a explicar diversos conceitos do mundo financeiro e o impacto de cada um em nossas vidas."
                      "\nPara visualizar ou fechar cada um dos conteúdos, basta clicar no tópico da sua preferência."
                      "\n\nAproveite para aprender e disseminar esse conteúdo com pessoas próximas de você!",
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ),
          actions: [TextButton(onPressed: () => Navigator.of(context).pop(), child: Text("Fechar"))],
        );
      },
    );
  }
}

class MyExpansionTile extends StatefulWidget {
  final String title;
  final String content;
  final String documentId;
  final int index;
  final int totalItems;
  final ScrollController scrollController;

  const MyExpansionTile({
    required this.title,
    required this.content,
    required this.documentId,
    required this.index,
    required this.totalItems,
    required this.scrollController,
  });

  @override
  _MyExpansionTileState createState() => _MyExpansionTileState();
}

class _MyExpansionTileState extends State<MyExpansionTile> {
  GlobalKey expansionTileKey = GlobalKey();
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      key: expansionTileKey,
      title: Text(
        widget.title,
        style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500, color: Colors.green[900]),
      ),
      onExpansionChanged: (bool expanded) {
        setState(() {
          _isExpanded = expanded;
        });

        if (expanded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _scrollToPosition(expansionTileKey, widget.scrollController);
          });

        }
      },
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.content, style: TextStyle(fontSize: 18)),
              SizedBox(height: 10),
              SingleChildScrollView(
                physics: NeverScrollableScrollPhysics(),
                child: _buildSubContent(context, widget.documentId),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubContent(BuildContext context, String docId) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance.collection('glossario').doc(docId).collection('subconteudo').orderBy('titulo').snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> subSnapshot) {
        if (subSnapshot.hasError) {
          return Text('Erro: ${subSnapshot.error}');
        }
        if (subSnapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        return ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: subSnapshot.data!.docs.map((DocumentSnapshot subDocument) {
            Map<String, dynamic> subData = subDocument.data() as Map<String, dynamic>;
            return MyExpansionTile(
              title: subData['titulo'],
              content: subData['texto'],
              documentId: subDocument.id,
              index: widget.index, // Use index from parent tile for consistent behavior
              totalItems: widget.totalItems,
              scrollController: widget.scrollController,
            );
          }).toList(),
        );
      },
    );
  }

  void _scrollToPosition(GlobalKey key, ScrollController scrollController) {
    final RenderBox box = key.currentContext!.findRenderObject() as RenderBox;
    final position = box.localToGlobal(Offset.zero);
    final targetOffset = scrollController.offset + position.dy - 91;  // 80 pixels from the top
    final maxScrollExtent = scrollController.position.maxScrollExtent;

    final newOffset = targetOffset > maxScrollExtent ? maxScrollExtent : targetOffset;

    scrollController.animateTo(
      newOffset,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
}
