import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GraficoDeBarras extends StatelessWidget {
  final List<Day> dias;

  const GraficoDeBarras({
    super.key,
    required this.dias,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      padding: const EdgeInsets.all(16.0),
      child: BarChart(BarChartData(
          gridData: const FlGridData(show: false),
          alignment: BarChartAlignment.spaceAround,
          maxY:
              dias.map((dia) => dia.valor).reduce((a, b) => a > b ? a : b) + 10,
          barTouchData: BarTouchData(enabled: false),
          borderData: FlBorderData(
            show: false,
          ),
          barGroups: dias.asMap().entries.map((entry) {
            int index = entry.key;
            Day dia = entry.value;
            return BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: dia.valor,
                  color: dia.valor < 0 ? Colors.red : Colors.green,
                  width: 20,
                ),
              ],
            );
          }).toList(),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );
                  Widget text;
                  if (value.toInt() >= 0 && value.toInt() < dias.length) {
                    text = Text(dias[value.toInt()].id, style: style);
                  } else {
                    text = const Text('', style: style);
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8,
                    child: text,
                  );
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(
                  showTitles: false), // Desativa as labels do lado direito
            ),
            topTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (double value, TitleMeta meta) {
                  const style = TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  );
                  Widget text;
                  if (value.toInt() >= 0 && value.toInt() < dias.length) {
                    text = const Text('');
                    //Text('R\$ ${dias[value.toInt()].valor.toString()}', style: style);
                  } else {
                    text = const Text('', style: style);
                  }
                  return SideTitleWidget(
                    axisSide: meta.axisSide,
                    space: 8,
                    child: text,
                  );
                },
              ),
            ),
          ))),
    );
  }
}

class Day {
  final String id;
  final double valor;

  Day({required this.id, required this.valor});
}
