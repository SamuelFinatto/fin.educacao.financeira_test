import 'package:flutter/material.dart';
import 'juros_compostos.dart';


class Conteudos extends StatefulWidget {

  @override
  _Conteudos createState() => _Conteudos();
}

class _Conteudos extends State<Conteudos> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conteúdos'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            MyExpansionTile(
              title: 'Simular juros compostos',
              content:
              'Conteúdo relacionado à simulação de juros compostos.\n'
                  'Conteúdo relacionado à simulação de juros compostos.\n'
                  'Conteúdo relacionado à simulação de juros compostos.\n'
                  'Conteúdo relacionado à simulação de juros compostos.\n'
                  'Conteúdo relacionado à simulação de juros compostos.\n'
                  'Conteúdo relacionado à simulação de juros compostos.\n',
            ),
            const SizedBox(height: 20),
            MyExpansionTile(
              title: 'Conteúdos sobre Educação Financeira',
              content: 'Conteúdo relacionado à educação financeira.',
            ),
            const SizedBox(height: 20),
            MyExpansionTile(
              title: 'Botão 2',
              content: 'Conteúdo relacionado ao botão 2.',
            ),
            const SizedBox(height: 20),
            MyExpansionTile(
              title: 'Botão 4',
              content: 'Conteúdo relacionado ao botão 4.',
            ),
          ],
        ),
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
      title: Text(widget.title),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(widget.content),
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
