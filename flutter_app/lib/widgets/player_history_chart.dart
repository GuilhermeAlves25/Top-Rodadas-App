import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/rodada.dart';

class PlayerHistoryChart extends StatelessWidget {
  final List<Rodada> rodadas;
  final Color lineColor;
  
  const PlayerHistoryChart({
    Key? key,
    required this.rodadas,
    this.lineColor = Colors.blue,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (rodadas.isEmpty) {
      return const Center(
        child: Text('Sem dados para exibir'),
      );
    }
    
    final List<FlSpot> spots = [];
    for (int i = 0; i < rodadas.length; i++) {
      spots.add(FlSpot(
        rodadas[i].rodadaId.toDouble(),
        rodadas[i].pontuacao,
      ));
    }
    
    final maxY = rodadas.map((r) => r.pontuacao).reduce((a, b) => a > b ? a : b);
    final minY = rodadas.map((r) => r.pontuacao).reduce((a, b) => a < b ? a : b);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Evolução de Pontos',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  horizontalInterval: 5,
                  verticalInterval: 1,
                ),
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        return SideTitleWidget(
                          axisSide: meta.axisSide,
                          child: Text(
                            'R${value.toInt()}',
                            style: const TextStyle(fontSize: 10),
                          ),
                        );
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 5,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey.shade300),
                ),
                minX: rodadas.first.rodadaId.toDouble(),
                maxX: rodadas.last.rodadaId.toDouble(),
                minY: (minY - 5).clamp(0, double.infinity),
                maxY: maxY + 5,
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: lineColor,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: lineColor,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: lineColor.withOpacity(0.1),
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
}
