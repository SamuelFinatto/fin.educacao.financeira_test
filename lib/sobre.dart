import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Sobre extends StatefulWidget {
  @override
  _SobreState createState() => _SobreState();
}

class _SobreState extends State<Sobre> {
  String appVersion = '';

  // Definindo três variáveis para controlar o estado das imagens
  bool showFirstImage = true;
  bool showSecondImage = false;
  bool showThirdImage = false;

  Color buttonColor0 = Colors.lightBlue; // Cor inicial do primeiro botão
  Color? buttonColor1 = Colors.green[800]; // Cor inicial do primeiro botão
  Color buttonColor2 = Colors.lightBlue; // Cor inicial do segundo botão
  Color buttonColor3 = Colors.lightBlue; // Cor inicial do terceiro botão

  void copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
  }

  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
    installerStore: 'Unknown',
  );

  @override
  void initState() {
    super.initState();
    _initPackageInfo();
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sobre'),
        backgroundColor:
        Colors.green.shade800, // Defina a cor desejada para a barra superior desta tela
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SizedBox(height: 20),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              '\nDesenvolvedor:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold, // Título em negrito
              ),
            ),
          ),
          const SizedBox(height: 7),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              'Jórdan Finatto',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0), // Adicionando padding horizontal
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Versão:',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  _packageInfo.version,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
