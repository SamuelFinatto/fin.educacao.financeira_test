import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class JurosCompostos extends StatefulWidget {
  @override
  _JurosCompostosState createState() => _JurosCompostosState();
}

class _JurosCompostosState extends State<JurosCompostos> {
  final TextEditingController _controller1 = TextEditingController();
  final TextEditingController _controller2 = TextEditingController();
  final TextEditingController _controller3 = TextEditingController();
  final TextEditingController _controller4 = TextEditingController();

  final NumberFormat _currencyFormat = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');

  final FocusNode _valorMensalFocusNode = FocusNode();
  final FocusNode _jurosFocusNode = FocusNode();
  final FocusNode _periodoFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller3.text = '0.80'; // Defina o valor inicial aqui
    _controller1.text = 'R\$ 0,00'; // Defina o valor inicial aqui
    _controller2.text = 'R\$ 0,00'; // Defina o valor inicial aqui
  }

  String formatCurrency(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    return _currencyFormat.format(double.parse(cleanValue) / 100);
  }

  String formatPercentage(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    final parsedValue = double.parse(cleanValue) / 100;
    return '${parsedValue.clamp(0, 10).toStringAsFixed(2)}';
  }

  String formatInteger(String value) {
    if (value.isEmpty) {
      return ''; // Retorna uma string vazia ou outra ação apropriada para um valor vazio
    }
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    return '${int.parse(cleanValue).clamp(0, 70)}';
  }

  double calculateCompoundInterest(double principal, double rate, int time) {
    return principal * pow((1 + rate), time);
  }

  double calculateFinalCompoundInterest(double principal, double taxa, int time, double valorMensal) {
    int n = 12; // Juros compostos mensais (considerando 12 meses por ano)
    double valorPresente = principal;
    double valorFuturo = 0.0;
    taxa = taxa / 100; // Convertendo a taxa percentual para decimal
    double taxaAnual = taxa / 100; // Convertendo taxa mensal para taxa anual equivalente
    if (taxa != 0) {
      valorFuturo = valorPresente * pow(1 + taxaAnual, n * time); // montante acumulado com juros compostos
      //print('valor futuro é: $valorFuturo');
      // Adiciona os aportes mensais usando a fórmula dos pagamentos iguais
      double valorFuturoAportes = valorMensal * ((pow(1 + taxaAnual, n * time) - 1) / taxaAnual);
      //print('valor valorFuturoAportes é: $valorMensal');
      valorFuturo += valorFuturoAportes;
    } else {
      valorFuturo = valorPresente + (valorMensal * time * 12);
    }
    return valorFuturo;
  }

  @override
  Widget build(BuildContext context) {
    double valorIntervaloGrafico = 10000;
    double intervaloHorizontal = 1;
    double valorMinY = 0;
    double valorMaxY = 100;
    double valorMaxYaux = 0;
    double valorAcumJuros = 0;
    double valorAcumInvest = 0;
    String valorPeriodo = _controller4.text.isEmpty ? '1' : _controller4.text;
    double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    if(_controller1.text.isNotEmpty && _controller2.text.isNotEmpty && _controller4.text.isNotEmpty){
      valorMaxYaux = (calculateFinalCompoundInterest(_controller1.text.isEmpty ? 0 : double.parse(_controller1.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')),
          _controller3.text.isEmpty ? 0 : double.parse(_controller3.text.replaceAll('.', '').replaceAll(',', '.')),
          _controller4.text.isEmpty ? 0 : int.parse(_controller4.text),
          _controller2.text.isEmpty ? 0 : double.parse(_controller2.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')))
      );

      valorMaxY = ((valorMaxYaux ~/ 5000) + 1) * 5000;
      int remainder = (valorMaxY % 5).toInt(); // Restante da divisão por 5

      if (remainder != 0) {
        int adjustment = 5 - remainder; // Ajuste necessário para torná-lo divisível por 5
        valorMaxY += adjustment; // Aplicando o ajuste
      }

      if(valorMaxY == 5000) {
        valorMaxY = ((valorMaxYaux ~/ 1000) + 1) * 1000;
        int remainder = (valorMaxY % 5).toInt(); // Restante da divisão por 5

        if (remainder != 0) {
          int adjustment = 5 - remainder; // Ajuste necessário para torná-lo divisível por 5
          valorMaxY += adjustment; // Aplicando o ajuste
        }
      }

      // int nextThousand = ((valorMaxY ~/ 1000) + 1) * 1000; // Próximo milhar
      // valorMaxY = nextThousand + (0 - (nextThousand % 5)); // Próximo milhar divisível por 5

      valorAcumInvest = (double.tryParse(_controller2.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')) ?? 0.0) * (_controller4.text.isEmpty ? 12 : double.parse(_controller4.text) * 12) + (double.parse(_controller1.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')));
    }

    if (valorMaxY == null || valorMaxY < 100) {
      valorMaxY = 100.0;
    }

    if(valorMaxY <= 20000) {
      valorIntervaloGrafico = 100;
    }


    intervaloHorizontal = (((valorMaxY + valorMaxY/10) ~/ valorIntervaloGrafico) * valorIntervaloGrafico);
    if(intervaloHorizontal == null || intervaloHorizontal == 0){
      intervaloHorizontal = 1;
    }
    //print('valorMaxY $valorMaxY');
    // print('teste $intervaloHorizontal');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simular Juros Compostos'),
        backgroundColor: Colors.green.shade800,
        actions: [
          Container( // Container para o IconButton
            margin: EdgeInsets.only(right: 10.0), // Margem à direita
            child: IconButton(
              icon: Icon(Icons.help_outline), // Ícone de informação
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
    body: SingleChildScrollView(
      //child: Container(
        //height: MediaQuery.of(context).size.height - 180, // Define a altura do Container
        //child: Stack(
        //children: <Widget>[
          // Aqui pode adicionar o restante do conteúdo abaixo do texto
          //Positioned(
            //top: 0, // Altura abaixo do texto principal
            //left: 0,
            //right: 15,
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [

                  const SizedBox(height: 5),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.0),
                    child: Row(
                      children: [ // Espaçamento entre o texto e a linha horizontal
                        Container(
                          height: 6,
                          width: 40, // Ajuste a largura da linha conforme necessário
                          color: Colors.lightBlue,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Montante total:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17, // Tamanho da fonte para o texto "Montante total"
                          ),
                        ),// Espaçamento entre a linha e o valor monetário
                        SizedBox(width: 12),
                        Text(
                          'R\$${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(valorMaxYaux)}', // Formata o valor para dinheiro BR
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18, // Tamanho da fonte para o valor monetário
                            color: Colors.black, // Cor do valor monetário
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.0),
                    child: Row(
                      children: [ // Espaçamento entre o texto e a linha horizontal
                        Container(
                          height: 6,
                          width: 40, // Ajuste a largura da linha conforme necessário
                          color: Colors.red,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Valor investido:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17, // Tamanho da fonte para o valor monetário
                          ),
                        ),
                        SizedBox(width: 11), // Espaçamento entre a linha e o valor monetário
                        Text(
                          'R\$${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(valorAcumInvest)}', // Formata o valor para dinheiro BR
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18, // Tamanho da fonte para o valor monetário
                            color: Colors.black, // Cor do valor monetário
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 3.0),
                    child: Row(
                      children: [ // Espaçamento entre o texto e a linha horizontal
                        Container(
                          height: 6,
                          width: 40, // Ajuste a largura da linha conforme necessário
                          color: Colors.orange,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Valor dos juros:',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 17, // Tamanho da fonte para o valor monetário
                          ),
                        ),
                        SizedBox(width: 10), // Espaçamento entre a linha e o valor monetário
                        Text(
                          'R\$${NumberFormat.currency(locale: 'pt_BR', symbol: '').format(valorMaxYaux - valorAcumInvest)}', // Formata o valor para dinheiro BR
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 18, // Tamanho da fonte para o valor monetário
                            color: Colors.black, // Cor do valor monetário
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 23),

                  // LINHA DO GRÁFICO
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: 13), // Margem de 10 pixels do lado direito
                          height: 220, // Defina a altura do gráfico
                          child: AbsorbPointer(
                            absorbing: true, // Defina como true para desativar os eventos de toque
                          child: LineChart(
                            LineChartData(
                              minX: 0,
                              maxX: double.parse(valorPeriodo) <= 10 ? double.parse(valorPeriodo) * 12 : double.parse(valorPeriodo),
                              minY: 0,
                              maxY: valorMaxY,
                              lineBarsData: [
                                lineChartBarData1_1,
                                lineChartBarData1_2,
                                lineChartBarData1_3
                              ],
                              borderData: FlBorderData(border: const Border(
                                  bottom: BorderSide(color: Colors.black54, width: 1),
                                  left: BorderSide(color: Colors.transparent),
                                  right: BorderSide(color: Colors.transparent),
                                  top: BorderSide(color: Colors.transparent))
                              ),
                              titlesData: FlTitlesData(
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                leftTitles: AxisTitles(sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: (valorMaxY > 500 ? 8 : 11)*(((valorMaxY / 100).ceil() * 100).toString()).length.toDouble(),
                                    interval: (valorMaxY < 5000 ? (valorMaxY / 2) : (valorMaxY / 5))
                                )),
                                bottomTitles: AxisTitles(sideTitles: SideTitles(
                                    showTitles: true,
                                    reservedSize: 27,
                                    interval: double.parse(valorPeriodo) <= 10 ? (double.parse(valorPeriodo) * 12)/6 :
                                              double.parse(valorPeriodo) <= 30 ? 6 :
                                              double.parse(valorPeriodo) <= 40 ? 8 : 10,
                                )),

                              ),
                              gridData: FlGridData(
                                show: true,
                                drawVerticalLine: false,
                                horizontalInterval: (valorMaxY < 5000 ? (valorMaxY / 2) : (valorMaxY / 5))-0.1, // necessário reduzir o mínimo que seja (em -0.01) para exibir a linha tracejada horizontal para o maior valor de Y
                                verticalInterval: 1,
                                getDrawingHorizontalLine: (value) {
                                  return const FlLine(
                                    color: Colors.black26,
                                    strokeWidth: 0.5,
                                    dashArray: [4], // Aqui, [5] define o comprimento dos traços e espaços
                                  );
                                },
                                getDrawingVerticalLine: (value) {
                                  return const FlLine(
                                    color: Colors.black54,
                                    strokeWidth: 1,
                                  );
                                },
                              ),
                            ),
                          ),
                          ),
                        ),
                      ),
                      // Mais widgets, se necessário
                    ],
                  ),

                  const SizedBox(height: 20),

                  // LINHA 1
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Valor inicial:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        width: 160, // Largura desejada do campo
                        height: 40, // Altura desejada do campo
                        child: TextFormField(
                          controller: _controller1,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(9),
                          ],
                          style: const TextStyle(fontSize: 18),
                          onFieldSubmitted: (_) {
                            // Quando o campo "Valor inicial" for submetido (pressão do botão "Enter"),
                            // defina o foco para o campo "Valor mensal"
                            FocusScope.of(context).requestFocus(_valorMensalFocusNode);
                          },
                          onChanged: (value) {
                            final formatted = formatCurrency(value);
                            final newCursorPosition = formatted.length;
                            setState(() {
                              _controller1.value = TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(offset: newCursorPosition < 0 ? 0 : newCursorPosition),
                              );
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  // VALOR MENSAL
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Valor mensal a investir:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        width: 133, // Largura desejada do campo
                        height: 40, // Altura desejada do campo
                        child: TextFormField(
                          controller: _controller2,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(8),
                          ],
                          style: const TextStyle(fontSize: 18),
                          focusNode: _valorMensalFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_jurosFocusNode);
                          },
                          onChanged: (value) {
                            final formatted = formatCurrency(value);
                            final newCursorPosition = formatted.length;
                            setState(() {
                              _controller2.value = TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(offset: newCursorPosition < 0 ? 0 : newCursorPosition),
                              );
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  // TAXA DE JUROS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Percentual de juros mensais: ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        width: 95, // Largura desejada do campo
                        height: 40, // Altura desejada do campo
                        child: TextFormField(
                          controller: _controller3,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(4),
                          ],
                          style: const TextStyle(fontSize: 18),
                          focusNode: _jurosFocusNode,
                          onFieldSubmitted: (_) {
                            FocusScope.of(context).requestFocus(_periodoFocusNode);
                          },
                          onChanged: (value) {
                            final formatted = formatPercentage(value);
                            final newCursorPosition = formatted.length;
                            setState(() {
                              _controller3.value = TextEditingValue(
                                text: formatted,
                                selection: TextSelection.collapsed(offset: newCursorPosition < 0 ? 0 : newCursorPosition),
                              );
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                            contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                            suffixText: '%', // Adiciona o texto "%" ao lado direito
                            suffixStyle: const TextStyle(fontSize: 18), // Estilo do texto do sufixo
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  // PERÍODO EM ANOS
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Período em anos:',
                        style: TextStyle(fontSize: 18),
                      ),
                      Container(
                        width: 95, // Largura desejada do campo
                        height: 40, // Altura desejada do campo
                        child: TextFormField(
                          controller: _controller4,
                          keyboardType: TextInputType.number,
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(2),
                          ],
                          style: const TextStyle(fontSize: 18),
                          focusNode: _periodoFocusNode,
                          onChanged: (value) {
                            if (value.isNotEmpty && (int.parse(value) < 1 || int.parse(value) > 70) ) {
                                // Se o valor digitado estiver fora do intervalo desejado, defina-o para o limite mais próximo
                                setState(() {
                                  _controller4.text = (int.parse(value) < 1) ? '1' : '70';
                                });
                            } else {
                              final formatted = formatInteger(value);
                              final newCursorPosition = formatted.length;
                              setState(() {
                                _controller4.value = TextEditingValue(
                                  text: formatted,
                                  selection: TextSelection.collapsed(
                                      offset: newCursorPosition),
                                );
                              });
                            }
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                            contentPadding: EdgeInsets.symmetric(horizontal: 12),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // Adicione um botão para limpar os campos
                  Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF1000D3), Color(0xFF1A6BFF)], // Cores base do gradiente
                        begin: Alignment.topCenter, // Início do gradiente (cima)
                        end: Alignment.bottomCenter, // Fim do gradiente (baixo)
                      ),
                      borderRadius: BorderRadius.circular(8), // Adicione bordas arredondadas conforme necessário
                    ),
                    child: InkWell(
                      onTap: () {
                        _controller1.text = 'R\$ 0,00';
                        _controller2.text = 'R\$ 0,00';
                        _controller3.clear();
                        _controller4.clear();

                      },
                      child: Container(
                        width: 250,
                        height: 50,
                        alignment: Alignment.center,
                        child: Text(
                          'Limpar campos',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.white, // Cor do texto branca para melhor contraste
                          ),
                        ),
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        //],
      //),
    //),
    //),
    );
  }

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    color: Colors.lightBlue,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: _calculateSpotsDinheiroAcumulado(_controller3.text.isEmpty ? 0.0 : (double.parse(_controller3.text))/100),
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: Colors.orange,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: _calculateSpotsTotalJuros(_controller3.text.isEmpty ? 0.0 : (double.parse(_controller3.text))/100),
  );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
    isCurved: true,
    color: Colors.red,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: _calculateSpotsDinheiroInvestido(_controller3.text.isEmpty ? 0.0 : (double.parse(_controller3.text))/100),
  );

  List<FlSpot> _calculateSpotsTotalJuros(double rate) {
    final principal = 0.0;
    final List<FlSpot> spots = [];
    double valorInvestidoInicial = double.tryParse(_controller1.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')) ?? 0.0;
    double valorInvestidoMensal = double.tryParse(_controller2.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')) ?? 0.0;
    double interest = valorInvestidoInicial; // Inicialize o interesse como 0.0
    double totalJuros = 0.0;
    double tempoMeses = _controller4.text.isEmpty ? 12 : double.parse(_controller4.text) * 12;
    double tempoAnos = _controller4.text.isEmpty ? 12 : double.parse(_controller4.text);
    double yValuePontoI = 0.0;
    if (_controller1.text.isNotEmpty && _controller2.text.isNotEmpty && _controller4.text.isNotEmpty) {
      if (tempoMeses <= 120) {
        for (int i = 0; i <= tempoMeses; i++) {
          for (int j = 0; j <= i; j++) {
            List<FlSpot> spotsTotal = _calculateSpotsDinheiroAcumulado(rate);
            FlSpot? pontoi = spotsTotal[j];
            yValuePontoI = pontoi!.y;
          }
          totalJuros = yValuePontoI - interest;
          interest += valorInvestidoMensal;
          //print('interest $interest | yValuePontoI $yValuePontoI | totalJuros $totalJuros');
          spots.add(FlSpot(i.toDouble(), double.parse(totalJuros.toStringAsFixed(2))));
        }
      } else {
        for (int i = 0; i <= tempoAnos; i++) {
          for (int j = 0; j <= i; j++) {
            List<FlSpot> spotsTotal = _calculateSpotsDinheiroAcumulado(rate);
            FlSpot? pontoi = spotsTotal[j];
            yValuePontoI = pontoi!.y;
          }
          totalJuros = yValuePontoI - interest;
          interest += valorInvestidoMensal * 12;
          spots.add(FlSpot(i.toDouble(), double.parse(totalJuros.toStringAsFixed(2))));

          //print('Mês $i valor investido: $totalJuros');
        }
      }
    }
    return spots;
  }

  // calculo OK
  List<FlSpot> _calculateSpotsDinheiroInvestido (double rate) {
    var principal = double.tryParse(_controller1.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')) ?? 0.0;
    final List<FlSpot> spots = [];
    double lastInterest = 0.0;
    double valorInvestidoInicial = double.tryParse(_controller1.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')) ?? 0.0;
    double valorInvestidoMensal = double.tryParse(_controller2.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')) ?? 0.0;
    double interest = valorInvestidoInicial; // Inicialize o interesse como 0.0
    double tempoMeses = _controller4.text.isEmpty ? 12 : double.parse(_controller4.text) * 12;
    double tempoAnos = _controller4.text.isEmpty ? 12 : double.parse(_controller4.text);

    if (_controller1.text.isNotEmpty && _controller2.text.isNotEmpty  && _controller4.text.isNotEmpty) {
      if (tempoMeses <= 120) {
        for (int i = 0; i <= (tempoMeses); i++) {
          spots.add(FlSpot(i.toDouble(), interest));
          interest += valorInvestidoMensal;
        }
      } else {
        for (int i = 0; i <= (tempoAnos); i++) {
          spots.add(FlSpot(i.toDouble(), interest));
          interest += valorInvestidoMensal * 12;

          //print('Mês $i valor investido: $interest');
        }
      }
    }
    return spots;
  }

  // calculo OK
  List<FlSpot> _calculateSpotsDinheiroAcumulado(double rate) {
    final List<FlSpot> spots = [];
    double valorInvestidoInicial = double.tryParse(_controller1.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')) ?? 0.0;
    double aporteMensal = double.tryParse(_controller2.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')) ?? 0.0;
    double montante = valorInvestidoInicial;
    double taxaJuros = rate;
    double taxaAnual = taxaJuros; // Convertendo taxa mensal para taxa anual equivalente
    int n = 12; // Juros compostos mensais (considerando 12 meses por ano)
    double tempoMeses = _controller4.text.isEmpty ? 12 : double.parse(_controller4.text) * 12;
    double tempoAnos = _controller4.text.isEmpty ? 12 : double.parse(_controller4.text);

    if (_controller1.text.isNotEmpty && _controller2.text.isNotEmpty && _controller4.text.isNotEmpty) {
      double jurosCompostos = 0.0;
      spots.add(FlSpot(0, montante)); // Adiciona o ponto inicial com valor do investimento inicial
      //print('Mês 0: $montante');

      if (tempoMeses <= 120) {
        spots.add(FlSpot(1, montante = montante *(1+rate)+aporteMensal)); // Adiciona o ponto inicial com valor do investimento inicial
        //print('Mês 1: $montante');


        for (int i = 2; i <= tempoMeses; i++) {
          jurosCompostos = montante;
          for (int j = 1; j < i; j++) {
            jurosCompostos *= (1 + taxaJuros);
            if (i > 1) {
              jurosCompostos += aporteMensal;
            }
          }
          //print('Mês $i: $jurosCompostos final');

          spots.add(FlSpot(i.toDouble(), double.parse(jurosCompostos.toStringAsFixed(2))));
        }
      } else {
        // Calcula pontos anuais
        spots.add(FlSpot(1, montante = montante * pow(1 + taxaAnual, n) + (aporteMensal * ((pow(1 + taxaAnual, n) - 1) / taxaAnual)) ) ); // Adiciona o ponto inicial com valor do investimento inicial
        //print('Mês 1: $montante');

        for (int i = 2; i <= tempoAnos; i++) {
          jurosCompostos = valorInvestidoInicial * pow(1 + taxaAnual, n * i);
          jurosCompostos += aporteMensal * ((pow(1 + taxaAnual, n * (i)) - 1) / taxaAnual);

          double montanteCalculado = valorInvestidoInicial * pow(1 + taxaAnual, n * i);
          double aporteMensalCalculado = aporteMensal * ((pow(1 + taxaAnual, n * (i)) - 1) / taxaAnual);

          // print('Mês $i montante: $montanteCalculado');
          // print('Mês $i aporte: $aporteMensalCalculado');
          // print('Mês $i total: $jurosCompostos');

          //valorFuturo = valorPresente * pow(1 + taxaAnual, n * time); // montante acumulado com juros compostos
          //print('valor futuro é: $jurosCompostos');
          // Adiciona os aportes mensais usando a fórmula dos pagamentos iguais
          //double valorFuturoAportes = valorMensal * ((pow(1 + taxaAnual, n * time) - 1) / taxaAnual);

          spots.add(FlSpot(i.toDouble(), double.parse(jurosCompostos.toStringAsFixed(2))));
        }
      }
    }
    return spots;
  }
}
