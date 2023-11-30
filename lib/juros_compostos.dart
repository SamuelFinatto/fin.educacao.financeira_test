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

  String formatCurrency(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    return _currencyFormat.format(double.parse(cleanValue) / 100);
  }

  String formatPercentage(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    final parsedValue = double.parse(cleanValue) / 100;
    return '%${parsedValue.clamp(0, 100).toStringAsFixed(2)}';
  }

  String formatInteger(String value) {
    final cleanValue = value.replaceAll(RegExp(r'[^\d]'), '');
    return '${int.parse(cleanValue).clamp(0, 99)}';
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
    double valorIntervaloGrafico = 20000;
    double intervaloHorizontal = 1;
    double valorMinY = 0;
    double valorMaxY = (calculateFinalCompoundInterest(_controller1.text.isEmpty ? 0 : double.parse(_controller1.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')),
        _controller3.text.isEmpty ? 0 : double.parse(_controller3.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('%', '')),
        _controller4.text.isEmpty ? 0 : int.parse(_controller4.text),
        _controller2.text.isEmpty ? 0 : double.parse(_controller2.text.replaceAll('.', '').replaceAll(',', '.').replaceAll('R\$', '')))
        );
    String valorPeriodo = _controller4.text.isEmpty ? '1' : _controller4.text;

    if (valorMaxY == null || valorMaxY == 0.0) {
      valorMaxY = 100.0;
    }

    if(valorMaxY <= 20000) {
      valorIntervaloGrafico = 100;
    }


    intervaloHorizontal = (((valorMaxY + valorMaxY/10) ~/ valorIntervaloGrafico) * valorIntervaloGrafico);
    if(intervaloHorizontal == null || intervaloHorizontal == 0){
      intervaloHorizontal = 1;
    }
    // print('valorMaxY $valorMaxY');
    // print('teste $intervaloHorizontal');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voltar'),
      ),
      body: Stack(
        children: <Widget>[
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              color: Colors.white, // Cor de fundo do texto
              padding: const EdgeInsets.all(16.0),
              child: const Text(
                'Simulador de juros compostos',
                style: TextStyle(
                  fontSize: 22.0,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // Aqui pode adicionar o restante do conteúdo abaixo do texto
          Positioned(
            top: 20, // Altura abaixo do texto principal
            left: 0,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _controller1,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Valor inicial',
                    ),
                    style: const TextStyle(fontSize: 18),
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
                  ),
                  TextFormField(
                    controller: _controller2,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Valor mensal',
                    ),
                    style: const TextStyle(fontSize: 18),
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
                  ),
                  TextFormField(
                    controller: _controller3,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(12),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Taxa de juros mensal',
                    ),
                    style: const TextStyle(fontSize: 18),
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
                  ),
                  TextFormField(
                    controller: _controller4,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(2),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Período de:',
                    ),
                    style: const TextStyle(fontSize: 18),
                    onChanged: (value) {
                      if (value.isNotEmpty && int.parse(value) == 0) {
                        setState(() {
                          _controller4.text = ''; // Limpa o campo se zero for digitado
                        });
                      } else {
                        final formatted = formatInteger(value);
                        final newCursorPosition = formatted.length;
                        setState(() {
                          _controller4.value = TextEditingValue(
                            text: formatted,
                            selection: TextSelection.collapsed(offset: newCursorPosition),
                          );
                        });
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0), // Altere o valor para ajustar a posição
                    child: SizedBox(
                      height: 250,
                      child: LineChart(
                        LineChartData(
                          minX: 0,
                          maxX: double.parse(valorPeriodo)*12,
                          minY: 0,
                          maxY: ((valorMaxY + valorMaxY/10) ~/ valorIntervaloGrafico) * valorIntervaloGrafico,
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
                                  reservedSize: 10*(((valorMaxY / 100).ceil() * 100).toString()).length.toDouble(),
                                  interval: 5+((valorMaxY + valorMaxY/10) ~/ valorIntervaloGrafico) * valorIntervaloGrafico/5
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
                            horizontalInterval: intervaloHorizontal,
                            verticalInterval: 1,
                            getDrawingHorizontalLine: (value) {
                              return const FlLine(
                                color: Colors.black26,
                                strokeWidth: 1,
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
    isCurved: true,
    color: Colors.lightBlue,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: _calculateSpotsDinheiroAcumulado(_controller3.text.isEmpty ? 0.0 : (double.parse(_controller3.text.replaceAll('%', '')))/100),
  );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
    isCurved: true,
    color: Colors.orange,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: _calculateSpotsTotalJuros(_controller3.text.isEmpty ? 0.0 : (double.parse(_controller3.text.replaceAll('%', '')))/100),
  );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
    isCurved: true,
    color: Colors.red,
    barWidth: 3,
    isStrokeCapRound: true,
    dotData: const FlDotData(show: false),
    belowBarData: BarAreaData(show: false),
    spots: _calculateSpotsDinheiroInvestido(_controller3.text.isEmpty ? 0.0 : (double.parse(_controller3.text.replaceAll('%', '')))/100),
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
