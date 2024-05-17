import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class Metas extends StatefulWidget {
  final String email;

  const Metas({Key? key, required this.email}) : super(key: key);

  @override
  _MetasState createState() => _MetasState();
}

class _MetasState extends State<Metas> {
  final TextEditingController _periodoController = TextEditingController();
  final TextEditingController _valorController = TextEditingController();
  final FocusNode _valorFocusNode = FocusNode();
  String? _tipoPeriodoSelecionado;
  int _quantidadeMetas = 0;
  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  @override
  void initState() {
    super.initState();
    _tipoPeriodoSelecionado = 'anos';
    _contarMetas();
  }

  String formatCurrency(String value) {
    final cleanValue = value.replaceAll(RegExp(r'\D'), '');
    return _currencyFormat.format(double.parse(cleanValue) / 100);
  }

  Future<void> _contarMetas() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('metas')
        .where('email', isEqualTo: widget.email)
        .get();

    setState(() {
      _quantidadeMetas = snapshot.docs.length;
    });
  }

  Future<void> _salvarMetas() async {
    final String periodo = _periodoController.text;
    final double valor = double.tryParse(_valorController.text
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .replaceAll('R\$', '')) ??
        0.0;
    final String tipoPeriodo = _tipoPeriodoSelecionado ?? 'anos';

    if (periodo.isNotEmpty && valor > 0) {
      try {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('metas')
            .where('email', isEqualTo: widget.email)
            .get();

        if (snapshot.docs.length >= 20) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Você atingiu o limite máximo de 20 metas.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        }

        final DateTime now = DateTime.now();
        final int periodoInt = int.parse(periodo);
        DateTime dataFimParameta;

        if (tipoPeriodo == 'anos') {
          dataFimParameta = DateTime(now.year + periodoInt, now.month, now.day);
        } else {
          int futureYear = now.year;
          int futureMonth = now.month + periodoInt;

          while (futureMonth > 12) {
            futureMonth -= 12;
            futureYear += 1;
          }

          int lastDayOfFutureMonth =
              DateTime(futureYear, futureMonth + 1, 0).day;
          int futureDay = now.day;

          if (futureDay > lastDayOfFutureMonth) {
            futureDay = lastDayOfFutureMonth;
          }

          if (futureMonth == 2 && futureDay == 29 && !_isLeapYear(futureYear)) {
            futureDay = 28;
          }

          dataFimParameta = DateTime(futureYear, futureMonth, futureDay);
        }

        await FirebaseFirestore.instance.collection('metas').add({
          'periodo': periodo,
          'valor': valor,
          'tipoperiodo': tipoPeriodo,
          'email': widget.email,
          'datafimparameta': dataFimParameta,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Meta salva com sucesso!'),
            duration: Duration(seconds: 2),
          ),
        );

        _periodoController.clear();
        _valorController.clear();

        _contarMetas(); // Atualiza o contador de metas
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao salvar a meta. Tente novamente mais tarde.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _limparCampos() {
    setState(() {
      _periodoController.clear();
      _valorController.text = 'R\$ 0,00';
      _tipoPeriodoSelecionado = 'anos';
    });
  }

  Future<void> _excluirMeta(String id) async {
    try {
      await FirebaseFirestore.instance.collection('metas').doc(id).delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Meta excluída com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
      _contarMetas(); // Atualiza o contador de metas
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao excluir a meta. Tente novamente mais tarde.'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  bool _isLeapYear(int year) {
    if (year % 4 == 0) {
      if (year % 100 == 0) {
        if (year % 400 == 0) {
          return true;
        }
        return false;
      }
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Metas e Investimentos'),
        backgroundColor: Colors.green.shade800,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.green.shade800, // Cor de fundo das abas
              child: TabBar(
                labelStyle: TextStyle(fontSize: 18), // Aumenta o tamanho da fonte das Tabs em 3 unidades
                tabs: [
                  Tab(text: 'Metas'),
                  Tab(text: 'Investimentos'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildMetasTab(),
                  _buildInvestimentosTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetasTab() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Conteúdo da aba "Metas" aqui
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            // Alinha no final (inferior)
            children: [
              Expanded(
                child: Container(
                  height: 70,
                  // Altura para corresponder à altura do DropdownButtonFormField
                  child: TextFormField(
                    controller: _periodoController,
                    decoration: InputDecoration(
                      labelText: 'Período',
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                    ],
                    style: TextStyle(fontSize: 18),
                    // Aumenta o tamanho da fonte
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_valorFocusNode);
                    },
                  ),
                ),
              ),
              SizedBox(width: 10),
              Container(
                height: 56,
                // Altura para corresponder à altura do TextFormField
                width: 150,
                // Defina a largura desejada
                child: DropdownButtonFormField<String>(
                  value: _tipoPeriodoSelecionado,
                  onChanged: (String? newValue) {
                    setState(() {
                      _tipoPeriodoSelecionado = newValue!;
                    });
                  },
                  items: <String>['anos', 'meses']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(
                        value,
                        style: TextStyle(
                            fontSize:
                                18), // Aumente o tamanho da fonte, se necessário
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _valorController,
            focusNode: _valorFocusNode,
            decoration: InputDecoration(
              labelText: 'Valor',
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            onChanged: (value) {
              final previousCursorPosition =
                  _valorController.selection.baseOffset;
              final formatted = formatCurrency(value);
              final lengthDifference =
                  formatted.length - _valorController.text.length;
              final newCursorPosition =
                  (previousCursorPosition + lengthDifference) < 0
                      ? 0
                      : (previousCursorPosition + lengthDifference);
              setState(() {
                _valorController.value = TextEditingValue(
                  text: formatted,
                  selection: TextSelection.collapsed(offset: newCursorPosition),
                );
              });
            },
            style: TextStyle(fontSize: 18), // Aumenta o tamanho da fonte
          ),

          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF1000D3), Color(0xFF1A6BFF)],
                    // Cores base do gradiente
                    begin: Alignment.topCenter,
                    // Início do gradiente (cima)
                    end: Alignment.bottomCenter, // Fim do gradiente (baixo)
                  ),
                  borderRadius: BorderRadius.circular(
                      8), // Adicione bordas arredondadas conforme necessário
                ),
                child: InkWell(
                  onTap: _salvarMetas,
                  // Chame a função _salvarMetas ao clicar
                  child: Container(
                    width: 150, // Ajuste a largura conforme necessário
                    height: 45, // Ajuste a altura conforme necessário
                    alignment: Alignment.center,
                    child: Text(
                      'Salvar meta',
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
              Ink(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF960000), Color(0xFFFF2828)],
                    // Cores base do gradiente
                    begin: Alignment.topCenter,
                    // Início do gradiente (cima)
                    end: Alignment.bottomCenter, // Fim do gradiente (baixo)
                  ),
                  borderRadius: BorderRadius.circular(
                      8), // Adicione bordas arredondadas conforme necessário
                ),
                child: InkWell(
                  onTap: _limparCampos,
                  // Chame a função _limparCampos ao clicar
                  child: Container(
                    width: 150, // Ajuste a largura conforme necessário
                    height: 45, // Ajuste a altura conforme necessário
                    alignment: Alignment.center,
                    child: Text(
                      'Limpar campos',
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
          SizedBox(height: 20),
          Row(
            children: [
              Text('Suas metas:',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Text(
                '$_quantidadeMetas',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green),
              ),
            ],
          ),
          SizedBox(height: 10),
          Expanded(
            child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('metas')
                  .where('email', isEqualTo: widget.email)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                final List<QueryDocumentSnapshot> metas = snapshot.data!.docs;

                if (metas.isEmpty) {
                  return Center(child: Text('Nenhuma meta encontrada.'));
                }

                return ListView.builder(
                  itemCount: metas.length,
                  itemBuilder: (BuildContext context, int index) {
                    final Map<String, dynamic> data =
                        metas[index].data() as Map<String, dynamic>;
                    final Timestamp timestamp =
                        data['datafimparameta'] as Timestamp;
                    final DateTime dataFim = timestamp.toDate();
                    final String dataFimFormatada =
                        DateFormat('dd/MM/yyyy').format(dataFim);
                    final NumberFormat formatter =
                        NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
                    final String valorFormatado =
                        formatter.format(data['valor']);
                    final String id =
                        metas[index].id; // Obter o ID do documento

                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            'Em ${data['periodo']} ${data['tipoperiodo']}, valor de $valorFormatado\nData fim: $dataFimFormatada',
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.delete),
                            onPressed: () {
                              _excluirMeta(id);
                            },
                          ),
                        ),
                        if (index != metas.length - 1) Divider(),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInvestimentosTab() {
    return Center(
      child: Text('Conteúdo da aba "Investimentos"'),
    );
  }
}
