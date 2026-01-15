import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/ranking_provider.dart';
import '../providers/app_provider.dart';
import '../widgets/player_card.dart';
import 'player_list_screen.dart';
import 'ranking_screen.dart';
import 'comparison_screen.dart';
import 'scout_ranking_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);
  
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedRodada = 1;
  String? _selectedPosicao;
  
  final List<String> _posicoes = ['GOL', 'LAT', 'ZAG', 'MEI', 'ATA', 'TEC'];
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadData();
    });
  }
  
  void _loadData() {
    final rankingProvider = context.read<RankingProvider>();
    rankingProvider.loadRanking(
      rodada: _selectedRodada,
      posicao: _selectedPosicao,
      limite: 5,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final rankingProvider = context.watch<RankingProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rodadas FC'),
        backgroundColor: const Color(0xFF8B1538),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PlayerListScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.compare_arrows),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ComparisonScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _loadData();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Clube favorito
              if (appProvider.clubeFavorito != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  color: const Color(0xFFFFEBF0),
                  child: Row(
                    children: [
                      const Icon(Icons.shield, color: Color(0xFF8B1538)),
                      const SizedBox(width: 8),
                      Text(
                        'Seu clube: ${appProvider.clubeFavorito}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              
              // Filtros
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
                            _loadData();
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
                          _loadData();
                        },
                      ),
                    ),
                  ],
                ),
              ),
              
              // Top 5 da Rodada
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Top 5 da Rodada',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const RankingScreen(),
                              ),
                            );
                          },
                          child: const Text('Ver todos'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    
                    if (rankingProvider.isLoading)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (rankingProvider.errorMessage != null)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                size: 48,
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
                                onPressed: _loadData,
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        ),
                      )
                    else if (rankingProvider.ranking.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(32),
                          child: Text('Nenhum jogador encontrado'),
                        ),
                      )
                    else
                      ...rankingProvider.ranking.map((jogador) {
                        return PlayerCard(
                          jogador: jogador,
                          onTap: () {
                            // TODO: Navegar para tela de detalhes
                          },
                        );
                      }),
                  ],
                ),
              ),
              
              // Ações rápidas
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Explorar',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      children: [
                        _buildActionCard(
                          icon: Icons.sports_soccer,
                          title: 'Artilharia',
                          color: Colors.red,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScoutRankingScreen(
                                  title: 'Top Artilheiros',
                                  scoutType: 'gols',
                                ),
                              ),
                            );
                          },
                        ),
                        _buildActionCard(
                          icon: Icons.assist_walker,
                          title: 'Assistências',
                          color: Colors.orange,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScoutRankingScreen(
                                  title: 'Top Assistências',
                                  scoutType: 'assistencias',
                                ),
                              ),
                            );
                          },
                        ),
                        _buildActionCard(
                          icon: Icons.shield,
                          title: 'Defesa',
                          color: Colors.blue,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScoutRankingScreen(
                                  title: 'Top Desarmes',
                                  scoutType: 'desarmes',
                                ),
                              ),
                            );
                          },
                        ),
                        _buildActionCard(
                          icon: Icons.sports,
                          title: 'Goleiros',
                          color: const Color(0xFF8B1538),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ScoutRankingScreen(
                                  title: 'Top Goleiros',
                                  scoutType: 'defesas',
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: const Color(0xFF8B1538),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Jogadores',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Rankings',
          ),
        ],
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PlayerListScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const RankingScreen(),
              ),
            );
          }
        },
      ),
    );
  }
  
  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 48, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
