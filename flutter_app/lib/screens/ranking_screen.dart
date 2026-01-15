import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ranking_provider.dart';
import '../widgets/player_card.dart';
import 'player_detail_screen.dart';

class RankingScreen extends StatefulWidget {
  const RankingScreen({Key? key}) : super(key: key);
  
  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedRodada = 1;
  String? _selectedPosicao;
  
  final List<String> _posicoes = ['GOL', 'LAT', 'ZAG', 'MEI', 'ATA', 'TEC'];
  
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _loadRankingData();
      }
    });
    _loadRankingData();
  }
  
  void _loadRankingData() {
    final provider = context.read<RankingProvider>();
    
    switch (_tabController.index) {
      case 0: // Por Rodada
        provider.loadRanking(
          rodada: _selectedRodada,
          posicao: _selectedPosicao,
          limite: 20,
        );
        break;
      case 1: // Artilharia
        provider.loadTopScorers(
          rodada: null,
          limite: 20,
        );
        break;
      case 2: // Assistências
        provider.loadTopAssists(
          rodada: null,
          limite: 20,
        );
        break;
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final rankingProvider = context.watch<RankingProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rankings'),
        backgroundColor: const Color(0xFF8B1538),
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          indicatorColor: Colors.white,
          tabs: const [
            Tab(text: 'Por Rodada'),
            Tab(text: 'Artilharia'),
            Tab(text: 'Assistências'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Filtros
          if (_tabController.index == 0)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<int>(
                      decoration: InputDecoration(
                        labelText: 'Rodada',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      value: _selectedRodada,
                      items: List.generate(38, (index) => index + 1)
                          .map((rodada) {
                        return DropdownMenuItem(
                          value: rodada,
                          child: Text('Rodada $rodada'),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _selectedRodada = value;
                          });
                          _loadRankingData();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: 'Posição',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                      ),
                      value: _selectedPosicao,
                      items: [
                        const DropdownMenuItem(
                          value: null,
                          child: Text('Todas'),
                        ),
                        ..._posicoes.map((posicao) {
                          return DropdownMenuItem(
                            value: posicao,
                            child: Text(posicao),
                          );
                        }),
                      ],
                      onChanged: (value) {
                        setState(() {
                          _selectedPosicao = value;
                        });
                        _loadRankingData();
                      },
                    ),
                  ),
                ],
              ),
            ),
          
          // Lista de ranking
          Expanded(
            child: rankingProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : rankingProvider.errorMessage != null
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 64,
                                color: Colors.red,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                rankingProvider.errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadRankingData,
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : rankingProvider.ranking.isEmpty
                        ? const Center(
                            child: Text('Nenhum jogador encontrado'),
                          )
                        : RefreshIndicator(
                            onRefresh: () async {
                              _loadRankingData();
                            },
                            child: ListView.builder(
                              itemCount: rankingProvider.ranking.length,
                              itemBuilder: (context, index) {
                                final jogador = rankingProvider.ranking[index];
                                return PlayerCard(
                                  jogador: jogador,
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlayerDetailScreen(
                                          atletaId: jogador.atletaId,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            ),
                          ),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
