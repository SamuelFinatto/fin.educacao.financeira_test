import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Metas extends StatefulWidget {
  @override
  _MetasState createState() => _MetasState();
}

class _MetasState extends State<Metas> {
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
        title: Text('Metas Financeiras'),
        backgroundColor: Colors.green.shade800,
        actions: [
          Container( // Container para o IconButton
            margin: EdgeInsets.only(right: 10.0), // Margem à direita
            child: IconButton(
              icon: Icon(Icons.info_outline), // Ícone de informação
              onPressed: () {
                // Ao clicar no ícone, exibe um diálogo de ajuda
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text("Explicando a tela de simulação:"),
                      content: Text(
                        "Esta tela serve para simular juros compostos, de maneira que você possa entender o quanto um investimento pode render de juros ao longo do tempo."
                            "\nPara isso, preencha os campos disponíveis, considerando que:"
                            "\n- O Valor inicial, é um dinheiro que você possui ou não, para começar a investir."
                            "\n- Valor mensal a investir, é um dinheiro que você pretende investir todo mês."
                            "\n- Já o Percentual de juros mensais, é a taxa de juros que seu investimento pode render por mês. Para auxiliar, já deixamos preenchido um percentual normalmente utilizado por instituições financeiras."
                            "\n- E o Período em anos é o tempo que você pretende investir."
                            "\n\nPerceba que quanto maior o prazo do investimento, mais seu dinheiro irá trabalhar por você, aumentando seus ganhos.",
                        textAlign: TextAlign.justify, // Texto justificado
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Fechar"),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text(
              '\nDesenvolvedor:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 7),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: GestureDetector(
              onTap: () {
                // Adicione aqui a lógica para abrir um email
              },
              child: Text(
                'desenvolvimento.fin@gmail.com',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w400,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ),
          SizedBox(height: 30),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
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
                SizedBox(height: 5),
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
