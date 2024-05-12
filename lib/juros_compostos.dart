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
    return '${int.parse(cleanValue).clamp(0, 50)}';
  }

  double calculateCompoundInterest(double principal, double rate, int time) {
    return principal * pow((1 + rate), time);
  }

  double calculateFinalCompoundInterest(double principal, double rate, int time, double monthlyAddition) {
    int n = 12; // Juros compostos mensais (considerando 12 meses por ano)
    double amount = principal;
    if (rate != 0) {
      rate = rate / 100; // Convertendo a taxa percentual para decimal
      for (int i = 0; i < time*12; i++) {
        //print('$amount');
        amount = amount * (1 + rate/100); // Aplica juros no montante atual
        amount += monthlyAddition; // Adiciona o valor do aporte mensal
      }
    } else {
      // Calcula o montante apenas com adições mensais ao principal (sem juros)
      amount = principal + (monthlyAddition * time*12);
    }
    return amount;
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
        backgroundColor: Colors.green.shade800 // Defina a cor desejada para a barra superior desta tela
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
                              maxX: double.parse(valorPeriodo)*12,
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
                                    interval: (double.parse(valorPeriodo)*12)/6
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
                        'Taxa de juros mensal: ',
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
                            if (value.isNotEmpty && (int.parse(value) < 1 || int.parse(value) > 40) ) {
                                // Se o valor digitado estiver fora do intervalo desejado, defina-o para o limite mais próximo
                                setState(() {
                                  _controller4.text = (int.parse(value) < 1) ? '1' : '40';
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
    double yValuePontoI = 0.0;
    if (_controller1.text.isNotEmpty && _controller2.text.isNotEmpty  && _controller4.text.isNotEmpty) {
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
    }
    return spots;
  }

  List<FlSpot> _calculateSpotsDinheiroInvestido (double rate) {
    var principal = double.tryParse(_controller1.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')) ?? 0.0;
    final List<FlSpot> spots = [];
    double lastInterest = 0.0;
    double valorInvestidoInicial = double.tryParse(_controller1.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')) ?? 0.0;
    double valorInvestidoMensal = double.tryParse(_controller2.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')) ?? 0.0;
    double interest = valorInvestidoInicial; // Inicialize o interesse como 0.0
    if (_controller1.text.isNotEmpty && _controller2.text.isNotEmpty  && _controller4.text.isNotEmpty) {
      for (int i = 0; i <= (_controller4.text.isEmpty ? 12 : double.parse(_controller4.text) * 12); i++) {
        spots.add(FlSpot(i.toDouble(), interest));
        interest += valorInvestidoMensal;
      }
    }
    return spots;
  }

  List<FlSpot> _calculateSpotsDinheiroAcumulado(double rate) {
    final List<FlSpot> spots = [];
    double valorInvestidoInicial = double.tryParse(_controller1.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')) ?? 0.0;
    double aporteMensal = double.tryParse(_controller2.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')) ?? 0.0;
    double montante = valorInvestidoInicial;
    double taxaJuros = rate;
    double tempoMeses = _controller4.text.isEmpty ? 12 : double.parse(_controller4.text) * 12;

    if (_controller1.text.isNotEmpty && _controller2.text.isNotEmpty && _controller4.text.isNotEmpty) {
      spots.add(FlSpot(0, montante)); // Adiciona o ponto inicial com valor do investimento inicial
      //print('Mês 0: $montante');
      spots.add(FlSpot(1, montante = montante *(1+rate)+aporteMensal)); // Adiciona o ponto inicial com valor do investimento inicial
      //print('Mês 1: $montante');

      double jurosCompostos = 0.0;
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
    }
    return spots;
  }
}
