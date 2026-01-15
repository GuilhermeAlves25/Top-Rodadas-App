import 'package:flutter/material.dart';
import '../models/jogador_detalhe.dart';
import '../models/rodada.dart';
import '../services/player_service.dart';
import '../widgets/player_history_chart.dart';

class PlayerDetailScreen extends StatefulWidget {
  final int atletaId;
  
  const PlayerDetailScreen({
    Key? key,
    required this.atletaId,
  }) : super(key: key);
  
  @override
  State<PlayerDetailScreen> createState() => _PlayerDetailScreenState();
}

class _PlayerDetailScreenState extends State<PlayerDetailScreen> {
  final PlayerService _playerService = PlayerService();
  JogadorDetalhe? _jogador;
  List<Rodada> _rodadas = [];
  bool _isLoading = true;
  String? _errorMessage;
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }
  
  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final jogador = await _playerService.getPlayerDetails(widget.atletaId);
      final rodadas = await _playerService.getPlayerHistory(widget.atletaId, limite: 10);
      
      setState(() {
        _jogador = jogador;
        _rodadas = rodadas;
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
        title: Text(_jogador?.apelido ?? 'Detalhes do Jogador'),
        backgroundColor: const Color(0xFF8B1538),
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
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
                          onPressed: _loadData,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                )
              : _jogador == null
                  ? const Center(child: Text('Jogador não encontrado'))
                  : RefreshIndicator(
                      onRefresh: _loadData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [const Color(0xFF6B0F2A), const Color(0xFF8B1538)],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                              ),
                              child: Column(
                                children: [
                                  CircleAvatar(
                                    radius: 50,
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      _jogador!.apelido.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    _jogador!.apelido,
                                    style: const TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (_jogador!.clube != null) ...[
                                        const Icon(Icons.shield, color: Colors.white, size: 16),
                                        const SizedBox(width: 4),
                                        Text(
                                          _jogador!.clube!,
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                        const SizedBox(width: 16),
                                      ],
                                      if (_jogador!.posicao != null) ...[
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            _jogador!.posicao!,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF8B1538),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            // Estatísticas principais
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Estatísticas da Temporada',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildStatCard(
                                          'Pontos',
                                          _jogador!.pontuacaoTotal.toStringAsFixed(1),
                                          Icons.emoji_events,
                                          Colors.amber,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildStatCard(
                                          'Gols',
                                          _jogador!.g.toString(),
                                          Icons.sports_soccer,
                                          Colors.blue,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildStatCard(
                                          'Assistências',
                                          _jogador!.a.toString(),
                                          Icons.assist_walker,
                                          Colors.orange,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildStatCard(
                                          'Desarmes',
                                          _jogador!.ds.toString(),
                                          Icons.shield,
                                          const Color(0xFF8B1538),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildStatCard(
                                          'Faltas Sofridas',
                                          _jogador!.fs.toString(),
                                          Icons.sports,
                                          Colors.purple,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildStatCard(
                                          'Cartões',
                                          '${_jogador!.ca + _jogador!.cv}',
                                          Icons.credit_card,
                                          Colors.red,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            
                            const Divider(),
                            
                            // Gráfico de evolução
                            if (_rodadas.isNotEmpty)
                              PlayerHistoryChart(
                                rodadas: _rodadas.reversed.toList(),
                                lineColor: const Color(0xFF8B1538),
                              ),
                            
                            const Divider(),
                            
                            // Histórico de rodadas
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Últimas Rodadas',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  if (_rodadas.isEmpty)
                                    const Center(
                                      child: Text('Sem histórico de rodadas'),
                                    )
                                  else
                                    ..._rodadas.map((rodada) {
                                      return Card(
                                        margin: const EdgeInsets.only(bottom: 8),
                                        child: ListTile(
                                          leading: CircleAvatar(
                                            backgroundColor: const Color(0xFF8B1538),
                                            child: Text(
                                              'R${rodada.rodadaId}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          title: Text(
                                            '${rodada.pontuacao.toStringAsFixed(1)} pontos',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          subtitle: Text(
                                            'G: ${rodada.gols ?? 0} | A: ${rodada.assistencias ?? 0} | DS: ${rodada.desarmes ?? 0}',
                                          ),
                                        ),
                                      );
                                    }),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
    );
  }
  
  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
