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
  int _quantidadeInvestimentos = 0;
  final NumberFormat _currencyFormat =
      NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  final TextEditingController _instituicaoController = TextEditingController();
  final TextEditingController _nomeTituloController = TextEditingController();
  final TextEditingController _dataPosicaoController = TextEditingController();
  final TextEditingController _valorInvestController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tipoPeriodoSelecionado = 'anos';
    _contarMetas();
    _contarInvestimentos();
  }

  Future<void> _openDatePicker() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2015),
      lastDate: DateTime(2090),
    );
    if (pickedDate != null) {
      setState(() {
        _dataPosicaoController.text =
            DateFormat('dd/MM/yyyy').format(pickedDate);
      });
      // Fecha o teclado virtual
      FocusScope.of(context).unfocus();

      // Define o foco para o próximo campo
      FocusScope.of(context).nextFocus();
      FocusScope.of(context).nextFocus();
    }
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

  Future<void> _contarInvestimentos() async {
    final QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection('investimentos')
        .where('email', isEqualTo: widget.email)
        .get();

    setState(() {
      _quantidadeInvestimentos = snapshot.docs.length;
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

  // Método para salvar investimento no Firestore
  Future<void> _salvarInvestimento() async {
    // Implementar lógica para salvar investimento no Firestore
    String instituicao = _instituicaoController.text;
    String nomeTitulo = _nomeTituloController.text;
    // Obtém o valor como double
    final double valor = double.tryParse(_valorInvestController.text
            .replaceAll('.', '')
            .replaceAll(',', '.')
            .replaceAll('R\$', '')) ??
        0.0;
    // Converte a data da posição para DateTime
    DateTime dataPosicao =
        DateFormat('dd/MM/yyyy').parse(_dataPosicaoController.text);

    // Valida se os campos estão preenchidos
    if (instituicao.isEmpty ||
        nomeTitulo.isEmpty ||
        valor == 0.0 ||
        dataPosicao == null) {
      // Exibe uma mensagem de erro ou trata de outra forma
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos.'),
          duration: Duration(seconds: 2),
        ),
      );

      return;
    } else {
      try {
        final QuerySnapshot snapshot = await FirebaseFirestore.instance
            .collection('investimentos')
            .where('email', isEqualTo: widget.email)
            .get();

        if (snapshot.docs.length >= 100) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Você atingiu o limite máximo de 100 investimentos.'),
              duration: Duration(seconds: 2),
            ),
          );
          return;
        } else {
          // Aqui você pode adicionar a lógica para salvar os dados no Firestore
          // Exemplo:
          FirebaseFirestore.instance.collection('investimentos').add({
            'instituicao': instituicao,
            'nome_titulo': nomeTitulo,
            'data_posicao': dataPosicao,
            'valor': valor,
            'email': widget.email,
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Investimento salvo com sucesso!'),
              duration: Duration(seconds: 2),
            ),
          );

          // Limpar os campos após salvar
          _limparCamposInvest();
          _contarInvestimentos();
          // Fecha o teclado
          FocusScope.of(context).unfocus();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Erro ao salvar investimento. Tente novamente mais tarde.'),
            duration: Duration(seconds: 2),
          ),
        );
      }
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

  Future<void> _excluirInvestimento(String id) async {
    try {
      await FirebaseFirestore.instance
          .collection('investimentos')
          .doc(id)
          .delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Investimento excluído com sucesso!'),
          duration: Duration(seconds: 2),
        ),
      );
      _contarInvestimentos(); // Atualiza o contador de metas
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              'Erro ao excluir o investimento. Tente novamente mais tarde.'),
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

  // Método para limpar os campos de texto
  void _limparCamposInvest() {
    _instituicaoController.clear();
    _nomeTituloController.clear();
    _dataPosicaoController.clear();
    _valorInvestController.text = 'R\$ 0,00';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Metas e Investimentos'),
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
                      title:
                          Text("Explicando a tela de Metas e Investimentos:"),
                      insetPadding: EdgeInsets.symmetric(horizontal: 10.0),
                      // Adiciona preenchimento ao redor do conteúdo
                      content: SizedBox(
                        height: MediaQuery.of(context).size.height *
                            0.4, // Defina a altura desejada
                        child: Scrollbar(
                          thumbVisibility: true,
                          // Torna a barra de rolagem sempre visível
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 7.0),
                              // Adiciona um espaçamento de 5 pixeis na parte direita
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Esta tela serve para registrar de maneira fácil e objetiva, as suas metas pessoais ou familiares, além de anotar os valores que você possui investido em qualquer instituição financeira."
                                    "\n\nNa página Metas, preencha os campos disponíveis, considerando que:"
                                    "\n- Período é o tempo você está determinando para atingir a meta."
                                    "\n- Valor é o total que você pretende alcançar até a data fim."
                                    "\n\nNa página Investimentos, preencha os campos disponíveis, considerando que:"
                                    "\n- Instituição Financeira é o local onde você possui seu investimento."
                                    "\n- Nome do título financeiro é o produto em que você investe. Em caso de dúvida, verifique o extrato dos seus investimentos."
                                    "\n- Data da posição é quando você possuia o valor a ser registrado."
                                    "\n- Valor é o quanto você tem investido na Data informada.",
                                    textAlign: TextAlign.justify,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
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
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: <Widget>[
            Container(
              color: Colors.green.shade800, // Cor de fundo das abas
              child: TabBar(
                labelStyle: TextStyle(fontSize: 18),
                // Aumenta o tamanho da fonte das Tabs em 3 unidades
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
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                  height: 55.5,
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
                    selection:
                        TextSelection.collapsed(offset: newCursorPosition),
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
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
            Container(
              height: MediaQuery.of(context).size.height - 450, // 40% da altura da tela
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
                              "Em ${data['periodo']} ${data['tipoperiodo']}"
                              "\nValor de: $valorFormatado"
                              "\nData esperada: $dataFimFormatada",
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
      ),
    );
  }

  Widget _buildInvestimentosTab() {
    return LayoutBuilder(
      builder: (context, constraints) {
        double availableHeight = constraints.maxHeight;

        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _instituicaoController,
                    decoration: InputDecoration(
                      labelText: 'Instituição Financeira',
                      labelStyle: TextStyle(fontSize: 18),
                      // Aumenta o tamanho da fonte do label
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 0), // Ajusta o espaçamento interno
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    maxLength: 25,
                    // Limita o campo a 25 caracteres
                    onEditingComplete: () => FocusScope.of(context).nextFocus(),
                    style: TextStyle(
                        fontSize: 18), // Aumenta o tamanho da fonte do texto
                  ),
                  TextFormField(
                    controller: _nomeTituloController,
                    decoration: InputDecoration(
                      labelText: 'Nome do título financeiro',
                      contentPadding: EdgeInsets.symmetric(
                          vertical: 0), // Ajusta o espaçamento interno
                    ),
                    keyboardType: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    maxLength: 25,
                    // Limita o campo a 30 caracteres
                    onEditingComplete: () {
                      // Chama a função para abrir o calendário
                      _openDatePicker();
                    },
                    style: TextStyle(
                        fontSize: 18), // Aumenta o tamanho da fonte do texto
                  ),

                  //SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 2,
                        // Define a largura relativa do campo Data da posição
                        child: TextFormField(
                          controller: _dataPosicaoController,
                          decoration: InputDecoration(
                            labelText: 'Data da posição',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0), // Ajusta o espaçamento interno
                          ),
                          keyboardType: TextInputType.datetime,
                          textInputAction: TextInputAction.next,
                          readOnly: _dataPosicaoController.text.length >= 10,
                          // Impede a edição do campo quando estiver completo
                          onTap: () async {
                            if (_dataPosicaoController.text.length >= 10) {
                              // Se o campo estiver completo, abre o calendário diretamente
                              _openDatePicker();
                            } else {
                              // Caso contrário, permite a edição do campo
                              DateTime? pickedDate = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2015),
                                lastDate: DateTime(2090),
                              );
                              if (pickedDate != null) {
                                setState(() {
                                  _dataPosicaoController.text =
                                      DateFormat('dd/MM/yyyy')
                                          .format(pickedDate);
                                  FocusScope.of(context)
                                      .unfocus(); // Fecha o teclado virtual
                                });

                                // Mover o foco para o próximo campo após selecionar a data
                                FocusScope.of(context).nextFocus();
                              }
                            }
                          },
                          style: TextStyle(
                              fontSize:
                                  18), // Aumenta o tamanho da fonte do texto
                        ),
                      ),
                      SizedBox(width: 8),
                      // Adiciona um espaçamento entre os campos
                      Flexible(
                        flex: 3, // Define a largura relativa do campo Valor
                        child: TextFormField(
                          controller: _valorInvestController,
                          decoration: InputDecoration(
                            labelText: 'Valor',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 0), // Ajusta o espaçamento interno
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (value) {
                            final previousCursorPosition =
                                _valorInvestController.selection.baseOffset;
                            final formatted = formatCurrency(
                                value); // Suponho que você tenha uma função chamada formatCurrency para formatar o valor
                            final lengthDifference = formatted.length -
                                _valorInvestController.text.length;
                            final newCursorPosition =
                                (previousCursorPosition + lengthDifference) < 0
                                    ? 0
                                    : (previousCursorPosition +
                                        lengthDifference);
                            setState(() {
                              _valorInvestController.value = TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(
                                    offset: newCursorPosition),
                              );
                            });
                          },
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () =>
                              FocusScope.of(context).unfocus(),
                          style: TextStyle(
                              fontSize:
                                  18), // Aumenta o tamanho da fonte do texto
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF1000D3), Color(0xFF1A6BFF)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: _salvarInvestimento,
                          child: Container(
                            width: 175,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'Salvar investimento',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Ink(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFF960000), Color(0xFFFF2828)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: InkWell(
                          onTap: _limparCamposInvest,
                          child: Container(
                            width: 150,
                            height: 50,
                            alignment: Alignment.center,
                            child: Text(
                              'Limpar campos',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
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
                      Text('Seus investimentos:',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      SizedBox(width: 10),
                      Text(
                        '$_quantidadeInvestimentos',
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.green),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: MediaQuery.of(context).size.height - 480, // 40% da altura da tela
                    child: FutureBuilder<QuerySnapshot>(
                      future: FirebaseFirestore.instance
                          .collection('investimentos')
                          .where('email', isEqualTo: widget.email)
                          .get(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        final List<QueryDocumentSnapshot> investimentos =
                            snapshot.data!.docs;

                        if (investimentos.isEmpty) {
                          return Center(
                            child: Text(
                              'Nenhum investimento encontrado.',
                              textAlign: TextAlign.center,
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: investimentos.length <= 100
                              ? investimentos.length
                              : 100,
                          // Limita o número de investimentos a 100
                          itemBuilder: (BuildContext context, int index) {
                            final Map<String, dynamic> data =
                                investimentos[index].data()
                                    as Map<String, dynamic>;
                            final Timestamp timestamp =
                                data['data_posicao'] as Timestamp;
                            final DateTime dataPosicao = timestamp.toDate();
                            final String dataPosicaoFormatada =
                                DateFormat('dd/MM/yyyy').format(dataPosicao);
                            final NumberFormat formatter =
                                NumberFormat.currency(
                                    locale: 'pt_BR', symbol: 'R\$');
                            final String valorInvestFormatado =
                                formatter.format(data['valor']);
                            final String id = investimentos[index]
                                .id; // Obter o ID do documento

                            return Column(
                              children: [
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 4.0, horizontal: 25.0),
                                  // Ajuste o espaçamento aqui
                                  title: Text(
                                    "Instituição: ${data['instituicao']}"
                                    "\nInvestimento: ${data['nome_titulo']}"
                                    "\nEm $dataPosicaoFormatada"
                                    "\nValor de: $valorInvestFormatado",
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      _excluirInvestimento(id);
                                    },
                                  ),
                                ),
                                if (index != investimentos.length - 1 &&
                                    index != 99)
                                  Divider(),
                                // Adiciona um divisor apenas se não for o último elemento ou o 100º elemento
                              ],
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
