import 'package:flutter/material.dart';
import '../models/jogador.dart';
import '../models/comparacao.dart';
import '../models/rodada.dart';
import '../services/player_service.dart';
import '../widgets/comparison_chart.dart';

class ComparisonScreen extends StatefulWidget {
  const ComparisonScreen({Key? key}) : super(key: key);
  
  @override
  State<ComparisonScreen> createState() => _ComparisonScreenState();
}

class _ComparisonScreenState extends State<ComparisonScreen> {
  final PlayerService _playerService = PlayerService();
  
  Jogador? _jogador1;
  Jogador? _jogador2;
  Comparacao? _comparacao;
  List<Rodada> _rodadas1 = [];
  List<Rodada> _rodadas2 = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  Future<void> _selectPlayer(int playerNumber) async {
    // Buscar lista de jogadores
    try {
      final jogadores = await _playerService.getPlayers();
      
      if (!mounted) return;
      
      final selected = await showModalBottomSheet<Jogador>(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.9,
            builder: (context, scrollController) {
              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Color(0xFF8B1538),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Selecione um jogador',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: jogadores.length,
                      itemBuilder: (context, index) {
                        final jogador = jogadores[index];
                        return ListTile(
                          leading: CircleAvatar(
                            child: Text(jogador.apelido.substring(0, 1)),
                          ),
                          title: Text(jogador.apelido),
                          subtitle: Text('${jogador.clube} - ${jogador.posicao}'),
                          trailing: Text(
                            jogador.pontuacaoTotal.toStringAsFixed(1),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF8B1538),
                            ),
                          ),
                          onTap: () {
                            Navigator.pop(context, jogador);
                          },
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      );
      
      if (selected != null) {
        setState(() {
          if (playerNumber == 1) {
            _jogador1 = selected;
          } else {
            _jogador2 = selected;
          }
        });
        
        if (_jogador1 != null && _jogador2 != null) {
          _comparePlayer();
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao buscar jogadores: $e')),
        );
      }
    }
  }
  
  Future<void> _comparePlayer() async {
    if (_jogador1 == null || _jogador2 == null) return;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final comparacao = await _playerService.comparePlayer(
        _jogador1!.atletaId,
        _jogador2!.atletaId,
      );
      
      final rodadas1 = await _playerService.getPlayerHistory(
        _jogador1!.atletaId,
        limite: 10,
      );
      
      final rodadas2 = await _playerService.getPlayerHistory(
        _jogador2!.atletaId,
        limite: 10,
      );
      
      setState(() {
        _comparacao = comparacao;
        _rodadas1 = rodadas1.reversed.toList();
        _rodadas2 = rodadas2.reversed.toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Comparar Jogadores'),
        backgroundColor: const Color(0xFF8B1538),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Seleção de jogadores
              Row(
                children: [
                  Expanded(
                    child: _buildPlayerSelector(
                      'Jogador 1',
                      _jogador1,
                      Colors.blue,
                      () => _selectPlayer(1),
                    ),
                  ),
                  const SizedBox(width: 16),
                  const Icon(Icons.compare_arrows, size: 32, color: Colors.grey),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildPlayerSelector(
                      'Jogador 2',
                      _jogador2,
                      Colors.red,
                      () => _selectPlayer(2),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              if (_isLoading)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: CircularProgressIndicator(),
                  ),
                )
              else if (_errorMessage != null)
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        const Icon(Icons.error_outline, size: 64, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _comparePlayer,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                )
              else if (_comparacao != null) ...[
                // Comparação de médias
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Média de Pontos',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMediaCard(
                              _jogador1!.apelido,
                              _comparacao!.mediaPontosJogador1,
                              Colors.blue,
                            ),
                            _buildMediaCard(
                              _jogador2!.apelido,
                              _comparacao!.mediaPontosJogador2,
                              Colors.red,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Tabela comparativa
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Estatísticas',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildComparisonRow(
                          'Pontos Totais',
                          _comparacao!.jogador1.pontuacaoTotal,
                          _comparacao!.jogador2.pontuacaoTotal,
                        ),
                        _buildComparisonRow(
                          'Gols',
                          _comparacao!.jogador1.g.toDouble(),
                          _comparacao!.jogador2.g.toDouble(),
                        ),
                        _buildComparisonRow(
                          'Assistências',
                          _comparacao!.jogador1.a.toDouble(),
                          _comparacao!.jogador2.a.toDouble(),
                        ),
                        _buildComparisonRow(
                          'Desarmes',
                          _comparacao!.jogador1.ds.toDouble(),
                          _comparacao!.jogador2.ds.toDouble(),
                        ),
                        _buildComparisonRow(
                          'Faltas Sofridas',
                          _comparacao!.jogador1.fs.toDouble(),
                          _comparacao!.jogador2.fs.toDouble(),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Gráfico de comparação
                if (_rodadas1.isNotEmpty || _rodadas2.isNotEmpty)
                  Card(
                    child: ComparisonChart(
                      rodadas1: _rodadas1,
                      rodadas2: _rodadas2,
                      jogador1Nome: _jogador1!.apelido,
                      jogador2Nome: _jogador2!.apelido,
                    ),
                  ),
              ]
              else
                const Center(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Text(
                      'Selecione dois jogadores para comparar',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildPlayerSelector(
    String label,
    Jogador? jogador,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3), width: 2),
        ),
        child: Column(
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: color,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            if (jogador != null) ...[
              CircleAvatar(
                backgroundColor: color,
                child: Text(
                  jogador.apelido.substring(0, 1),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                jogador.apelido,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              Text(
                jogador.clube ?? '',
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ] else ...[
              Icon(Icons.add_circle_outline, size: 48, color: color),
              const SizedBox(height: 8),
              const Text('Selecionar'),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildMediaCard(String nome, double media, Color color) {
    return Column(
      children: [
        Text(
          nome,
          style: TextStyle(
            fontSize: 14,
            color: color,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          media.toStringAsFixed(2),
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const Text(
          'pts/jogo',
          style: TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }
  
  Widget _buildComparisonRow(String label, double value1, double value2) {
    final max = value1 > value2 ? value1 : value2;
    final percentage1 = max > 0 ? value1 / max : 0.0;
    final percentage2 = max > 0 ? value2 / max : 0.0;
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      value1.toStringAsFixed(value1 % 1 == 0 ? 0 : 1),
                      style: TextStyle(
                        fontWeight: value1 > value2 ? FontWeight.bold : FontWeight.normal,
                        color: value1 > value2 ? Colors.blue : Colors.grey,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: LinearProgressIndicator(
                        value: percentage1,
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: percentage2,
                        backgroundColor: Colors.red.withOpacity(0.2),
                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      value2.toStringAsFixed(value2 % 1 == 0 ? 0 : 1),
                      style: TextStyle(
                        fontWeight: value2 > value1 ? FontWeight.bold : FontWeight.normal,
                        color: value2 > value1 ? Colors.red : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
