import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';

class Metas extends StatefulWidget {
  final String email;

  const Metas({Key? key, required this.email}) : super(key: key);

  @override
  _MetasState createState() => _MetasState();
}

class _MetasState extends State<Metas> {
  final TextEditingController _periodoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();

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

  Future<void> _salvarMetas() async {
    final String periodo = _periodoController.text;
    final double valor = double.tryParse(_valorController.text) ?? 0.0;

    // Verifica se os campos não estão vazios
    if (periodo.isNotEmpty && valor > 0) {
      try {
        // Salvando os dados no Firestore com ID aleatório
        await FirebaseFirestore.instance.collection('metas').add({
          'periodo': periodo,
          'valor': valor,
          'email': widget.email, // Adicionando o email como filtro
        });

        // Exibindo uma mensagem de sucesso
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Metas salvas com sucesso!'),
            duration: Duration(seconds: 2),
          ),
        );

        // Limpando os campos
        _periodoController.clear();
        _valorController.clear();

        // Atualizando o estado da tela para recarregar a lista de metas
        setState(() {});
      } catch (e) {
        // Em caso de erro, exibindo uma mensagem de erro
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar as metas. Tente novamente mais tarde.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      // Se os campos estiverem vazios, exibindo uma mensagem de erro
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }



  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Metas Financeiras'),
        backgroundColor: Colors.green.shade800,
        actions: [
          Container(
            margin: EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
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
                        textAlign: TextAlign.justify,
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
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _periodoController,
                    decoration: InputDecoration(
                      labelText: 'Período',
                    ),
                    keyboardType: TextInputType.number, // Define o tipo de teclado como número
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly // Permite apenas números
                    ],
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: 'Anos', // Valor inicial do botão de seleção
                  onChanged: (String? newValue) {
                    setState(() {
                      // Atualiza o valor do botão de seleção
                      // Você pode adicionar lógica aqui para atualizar o valor do período
                    });
                  },
                  items: <String>['Anos', 'Meses'] // Opções disponíveis
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            SizedBox(height: 20),
            TextFormField(
              controller: _valorController,
              decoration: InputDecoration(
                labelText: 'Valor',
              ),
              keyboardType: TextInputType.numberWithOptions(decimal: true),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _salvarMetas,
              child: Text('Salvar Metas'),
            ),
            SizedBox(height: 20),
            Text('Suas metas:', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('metas')
                    .where('email', isEqualTo: widget.email)
                    .get(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: Text('Carregando...'), // Exibe um texto indicando que os dados estão sendo buscados
                    );
                  } else if (snapshot.hasError) {
                    return Text('Erro ao carregar os dados: ${snapshot.error}');
                  } else {
                    final List<DocumentSnapshot> metas = snapshot.data!.docs;
                    return ListView.builder(
                      itemCount: metas.length,
                      itemBuilder: (BuildContext context, int index) {
                        final Map<String, dynamic> data = metas[index].data() as Map<String, dynamic>;
                        return ListTile(
                          title: Text('Em ${data['periodo']}, valor de R\$ ${data['valor']}'),
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
