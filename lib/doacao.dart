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
                    '- promover educação gratuita;\n'
                    '- ajudar a diminuir a desigualdade social no médio/longo prazo.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                ),
                textAlign: TextAlign.justify, // Define o alinhamento do texto como justificado
              ),
            ),

            SizedBox(height: 15), // Espaço entre os botões e a imagem

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: buttonColorChaveAleatoria == Colors.green ? [Colors.green.shade800, Colors.green.shade500] : [Color(0xFF1000D3), Color(0xFF1A6BFF)],
                        // Cores base do gradiente
                        begin: Alignment.topCenter,
                        // Início do gradiente (cima)
                        end: Alignment.bottomCenter, // Fim do gradiente (baixo)
                      ),
                      borderRadius: BorderRadius.circular(
                        8,
                      ), // Adicione bordas arredondadas conforme necessário
                    ),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          buttonColorChaveAleatoria = Colors.green;
                          copyToClipboard('52b22219-8ef1-4472-bd25-a4f5a16ff88d');
                          _showCustomSnackBar(context, 'Chave PIX copiada.\nAcesse o app do seu banco.');
                        });
                      },
                      // Chame a função _salvarMetas ao clicar
                      child: Container(
                        width: 300, // Ajuste a largura conforme necessário
                        height: 45, // Ajuste a altura conforme necessário
                        alignment: Alignment.center,
                        child: Text(
                          'Copiar chave PIX aleatória',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors
                                .white, // Cor do texto branca para melhor contraste
                          ),
                        ),
                      ),
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
                width: 220,
                height: 220,
              )
                  : showSecondImage
                  ? Image.asset(
                'assets/images/qrcodepix_cinquenta.png',
                width: 220,
                height: 220,
              )
                  : Image.asset(
                'assets/images/qrcodepix.png',
                width: 220,
                height: 220,
              ),
            ),

            SizedBox(height: 15), // Adiciona um espaço de 20 pixels

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Alterar valor do QR Code:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold, // Título em negrito
                ),
              ),
            ),

            SizedBox(height: 7), // Adiciona um espaço de 20 pixels

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: buttonColor1 == Colors.green ? [Colors.green.shade800, Colors.green.shade500] : [Color(0xFF1000D3), Color(0xFF1A6BFF)],
                      // Cores base do gradiente
                      begin: Alignment.topCenter,
                      // Início do gradiente (cima)
                      end: Alignment.bottomCenter, // Fim do gradiente (baixo)
                    ),
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Adicione bordas arredondadas conforme necessário
                  ),
                  child: InkWell(
                    onTap: () {
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
                    // Chame a função _salvarMetas ao clicar
                    child: Container(
                      width: 90, // Ajuste a largura conforme necessário
                      height: 45, // Ajuste a altura conforme necessário
                      alignment: Alignment.center,
                      child: Text(
                        'R\$ 15,00',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors
                              .white, // Cor do texto branca para melhor contraste
                        ),
                      ),
                    ),
                  ),
                ),


                SizedBox(width: 15), // Espaço entre os botões

                Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: buttonColor2 == Colors.green ? [Colors.green.shade800, Colors.green.shade500] : [Color(0xFF1000D3), Color(0xFF1A6BFF)],
                      // Cores base do gradiente
                      begin: Alignment.topCenter,
                      // Início do gradiente (cima)
                      end: Alignment.bottomCenter, // Fim do gradiente (baixo)
                    ),
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Adicione bordas arredondadas conforme necessário
                  ),
                  child: InkWell(
                    onTap: () {
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
                    // Chame a função _salvarMetas ao clicar
                    child: Container(
                      width: 90, // Ajuste a largura conforme necessário
                      height: 45, // Ajuste a altura conforme necessário
                      alignment: Alignment.center,
                      child: Text(
                        'R\$ 50,00',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors
                              .white, // Cor do texto branca para melhor contraste
                        ),
                      ),
                    ),
                  ),
                ),


                SizedBox(width: 15), // Espaço entre os botões

                Ink(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: buttonColor3 == Colors.green ? [Colors.green.shade800, Colors.green.shade500] : [Color(0xFF1000D3), Color(0xFF1A6BFF)],
                      // Cores base do gradiente
                      begin: Alignment.topCenter,
                      // Início do gradiente (cima)
                      end: Alignment.bottomCenter, // Fim do gradiente (baixo)
                    ),
                    borderRadius: BorderRadius.circular(
                      8,
                    ), // Adicione bordas arredondadas conforme necessário
                  ),
                  child: InkWell(
                    onTap: () {
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
                    // Chame a função _salvarMetas ao clicar
                    child: Container(
                      width: 90, // Ajuste a largura conforme necessário
                      height: 45, // Ajuste a altura conforme necessário
                      alignment: Alignment.center,
                      child: Text(
                        'Livre',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors
                              .white, // Cor do texto branca para melhor contraste
                        ),
                      ),
                    ),
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
