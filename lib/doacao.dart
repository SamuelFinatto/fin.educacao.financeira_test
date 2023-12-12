import 'package:flutter/material.dart';

class Doacao extends StatefulWidget {
  @override
  _DoacaoState createState() => _DoacaoState();
}

class _DoacaoState extends State<Doacao> {
  // Definindo três variáveis para controlar o estado das imagens
  bool showFirstImage = true;
  bool showSecondImage = false;
  bool showThirdImage = false;

  Color? buttonColor1 = Colors.green[800]; // Cor inicial do primeiro botão
  Color buttonColor2 = Colors.lightBlue; // Cor inicial do segundo botão
  Color buttonColor3 = Colors.lightBlue; // Cor inicial do terceiro botão

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Doação Voluntária'),
        backgroundColor: Colors.green.shade800 // Defina a cor desejada para a barra superior desta tela
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

          SizedBox(height: 10), // Espaço entre os botões e a imagem
          Center(
            child: showFirstImage
                ? Image.asset(
                    'assets/images/qrcodepix_quinze.png',
                    width: 280,
                    height: 280,
                  )
                : showSecondImage
                    ? Image.asset(
                        'assets/images/qrcodepix_cinquenta.png',
                        width: 280,
                        height: 280,
                      )
                    : Image.asset(
                        'assets/images/qrcodepix.png',
                        width: 280,
                        height: 280,
                      ),
          ),

          SizedBox(height: 10), // Espaço entre os botões e a imagem

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Atualiza o estado dos botões e a cor do botão ativo
                    showFirstImage = true;
                    showSecondImage = false;
                    showThirdImage = false;

                    // Define a cor do botão ativo e mantém a cor padrão para os outros
                    buttonColor1 = Colors.green;
                    buttonColor2 = Colors.blue;
                    buttonColor3 = Colors.blue;
                  });
                },
                style: ElevatedButton.styleFrom(primary: buttonColor1), // Cor do botão
                child: const Text(
                  'R\$ 15,00',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(width: 15), // Espaço entre os botões
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Atualiza o estado dos botões e a cor do botão ativo
                    showFirstImage = false;
                    showSecondImage = true;
                    showThirdImage = false;

                    // Define a cor do botão ativo e mantém a cor padrão para os outros
                    buttonColor1 = Colors.blue;
                    buttonColor2 = Colors.green;
                    buttonColor3 = Colors.blue;
                  });
                },
                style: ElevatedButton.styleFrom(primary: buttonColor2), // Cor do botão
                child: const Text(
                  'R\$ 50,00',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              SizedBox(width: 15), // Espaço entre os botões
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    // Atualiza o estado dos botões e a cor do botão ativo
                    showFirstImage = false;
                    showSecondImage = false;
                    showThirdImage = true;

                    // Define a cor do botão ativo e mantém a cor padrão para os outros
                    buttonColor1 = Colors.blue;
                    buttonColor2 = Colors.blue;
                    buttonColor3 = Colors.green;
                  });
                },
                style: ElevatedButton.styleFrom(primary: buttonColor3), // Cor do botão
                child: const Text(
                  'Livre',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),


          const SizedBox(height: 10),
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
