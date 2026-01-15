import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/rodada.dart';

class ComparisonChart extends StatelessWidget {
  final List<Rodada> rodadas1;
  final List<Rodada> rodadas2;
  final String jogador1Nome;
  final String jogador2Nome;
  
  const ComparisonChart({
    Key? key,
    required this.rodadas1,
    required this.rodadas2,
    required this.jogador1Nome,
    required this.jogador2Nome,
  }) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (rodadas1.isEmpty && rodadas2.isEmpty) {
      return const Center(
        child: Text('Sem dados para comparar'),
      );
    }
    
    final List<FlSpot> spots1 = rodadas1.map((r) {
      return FlSpot(r.rodadaId.toDouble(), r.pontuacao);
    }).toList();
    
    final List<FlSpot> spots2 = rodadas2.map((r) {
      return FlSpot(r.rodadaId.toDouble(), r.pontuacao);
    }).toList();
    
    final allRodadas = [...rodadas1, ...rodadas2];
    final maxY = allRodadas.map((r) => r.pontuacao).reduce((a, b) => a > b ? a : b);
    final minY = allRodadas.map((r) => r.pontuacao).reduce((a, b) => a < b ? a : b);
    
    final minRodada = allRodadas.map((r) => r.rodadaId).reduce((a, b) => a < b ? a : b);
    final maxRodada = allRodadas.map((r) => r.rodadaId).reduce((a, b) => a > b ? a : b);
    
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Comparação de Desempenho',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          
          // Legenda
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 20,
                height: 3,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  jogador1Nome,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 20),
              Container(
                width: 20,
                height: 3,
                color: Colors.red,
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  jogador2Nome,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          SizedBox(
            height: 250,
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
                minX: minRodada.toDouble(),
                maxX: maxRodada.toDouble(),
                minY: (minY - 5).clamp(0, double.infinity),
                maxY: maxY + 5,
                lineBarsData: [
                  // Jogador 1
                  LineChartBarData(
                    spots: spots1,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.blue,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.withOpacity(0.1),
                    ),
                  ),
                  // Jogador 2
                  LineChartBarData(
                    spots: spots2,
                    isCurved: true,
                    color: Colors.red,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.red,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.red.withOpacity(0.1),
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
