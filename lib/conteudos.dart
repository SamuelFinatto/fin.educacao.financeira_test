import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Conteudos extends StatefulWidget {
  @override
  _ConteudosState createState() => _ConteudosState();
}

class _ConteudosState extends State<Conteudos> {
  late String documentId;
  late String collectionName = 'conteudo'; // Nome da coleção pai

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conteúdos'),
        backgroundColor: Colors.green.shade800,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection(collectionName).orderBy('titulo').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Erro ao carregar os dados: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              documentId = document.id; // Armazena o ID do documento atual
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return MyExpansionTile(
                title: data['titulo'],
                content: data['texto'],
                documentId: documentId,
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class MyExpansionTile extends StatelessWidget {
  final String title;
  final String content;
  final String documentId;

  const MyExpansionTile({
    required this.title,
    required this.content,
    required this.documentId,
  });

  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.w500,
          color: Colors.green[900],
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                content,
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView( // Use SingleChildScrollView aqui
                physics: NeverScrollableScrollPhysics(), // Desativa a rolagem para evitar conflitos
                child: Column(
                  children: [
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection('conteudo').doc(documentId).collection('subconteudo').orderBy('titulo').snapshots(),
                      builder: (context, subSnapshot) {
                        if (subSnapshot.hasError) {
                          return Text('Erro: ${subSnapshot.error}');
                        }

                        if (subSnapshot.connectionState == ConnectionState.waiting) {
                          return CircularProgressIndicator();
                        }

                        return ListView(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(), // Desativa a rolagem para evitar conflitos
                          children: subSnapshot.data!.docs.map((DocumentSnapshot subDocument) {
                            Map<String, dynamic> subData = subDocument.data() as Map<String, dynamic>;
                            return MyExpansionTile(
                              title: subData['titulo'],
                              content: subData['texto'],
                              documentId: subDocument.id,
                            );
                          }).toList(),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
