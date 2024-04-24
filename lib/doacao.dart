import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'components/custom_snack_bar.dart';

class Doacao extends StatefulWidget {
  @override
  _DoacaoState createState() => _DoacaoState();
}

class _DoacaoState extends State<Doacao> {
  // Definindo três variáveis para controlar o estado das imagens
  bool showFirstImage = true;
  bool showSecondImage = false;
  bool showThirdImage = false;

  Color buttonColorChaveAleatoria = Colors.lightBlue; // Cor inicial do primeiro botão
  Color buttonColor0 = Colors.lightBlue; // Cor inicial do primeiro botão
  Color buttonColor1 = Colors.green; // Cor inicial do primeiro botão
  Color buttonColor2 = Colors.lightBlue; // Cor inicial do segundo botão
  Color buttonColor3 = Colors.lightBlue; // Cor inicial do terceiro botão

  bool _isSnackBarVisible = false;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  @override
  void initState() {
    super.initState();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  void _showCustomSnackBar(BuildContext context, String message) {
    if (_isSnackBarVisible) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      _isSnackBarVisible = false;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: CustomSnackBar(message: message),
        duration: Duration(milliseconds: 2500),
        behavior: SnackBarBehavior.floating,
        elevation: 6, // Adiciona elevação para garantir espaço suficiente
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );

    _isSnackBarVisible = true;
  }






  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
          title: Text('Doação Voluntária'),
          backgroundColor: Colors.green.shade800 // Defina a cor desejada para a barra superior desta tela
      ),
      body: Builder(
        builder: (context) => Column(
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

            SizedBox(height: 15), // Espaço entre os botões e a imagem

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        buttonColorChaveAleatoria = Colors.green;
                        copyToClipboard('52b22219-8ef1-4472-bd25-a4f5a16ff88d');
                        _showCustomSnackBar(context, 'Chave PIX copiada.\nAcesse o app do seu banco.');
                      });
                    },
                    style: ElevatedButton.styleFrom(primary: buttonColorChaveAleatoria),
                    child: const Text(
                      'Copiar chave PIX aleatória',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),



            SizedBox(height: 20), // Espaço entre os botões e a imagem
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


            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                '\nAlterar valor do QR Code:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold, // Título em negrito
                ),
              ),
            ),

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

                      _showCustomSnackBar(context, 'QR Code alterado para R\$ 15,00.');
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

                      _showCustomSnackBar(context, 'QR Code alterado para R\$ 50,00.');
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

                      _showCustomSnackBar(context, 'QR Code alterado para valor "livre".');
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
          ],
        ),
      ),
    );
  }
}
