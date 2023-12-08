import 'package:flutter/material.dart';

class Doacao extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doação voluntária'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Sua doação tem como propósito:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold, // Título em negrito
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              '- a manutenção e evolução do app;\n'
                  '- promover educação financeira gratuita para a população brasileira;\n'
                  '- ajudar a diminuir a desigualdade social no médio/longo prazo.',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Image.asset(
              'assets/images/qrcodepix.png',
              width: 280,
              height: 280,
            ),
          ),
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Desenvolvedores:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold, // Título em negrito
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
                  '- Henrique Franceschini\n'
                  '- João Vitor Goergen Schonarth\n'
                  '- Jórdan Finatto',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
