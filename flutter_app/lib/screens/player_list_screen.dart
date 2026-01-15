import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/player_provider.dart';
import '../services/player_service.dart';
import '../widgets/player_card.dart';
import 'player_detail_screen.dart';

class PlayerListScreen extends StatefulWidget {
  const PlayerListScreen({Key? key}) : super(key: key);
  
  @override
  State<PlayerListScreen> createState() => _PlayerListScreenState();
}

class _PlayerListScreenState extends State<PlayerListScreen> {
  final TextEditingController _searchController = TextEditingController();
  final PlayerService _playerService = PlayerService();
  String? _selectedClube;
  String? _selectedPosicao;
  Timer? _debounce;
  
  List<String> _clubes = [];
  bool _loadingClubes = true;
  
  final List<String> _posicoes = ['GOL', 'LAT', 'ZAG', 'MEI', 'ATA', 'TEC'];
  
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PlayerProvider>().loadPlayers();
      _loadClubes();
    });
  }
  
  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }
  
  Future<void> _loadClubes() async {
    try {
      final clubes = await _playerService.getClubes();
      setState(() {
        _clubes = clubes;
        _loadingClubes = false;
      });
    } catch (e) {
      setState(() {
        _loadingClubes = false;
      });
    }
  }
  
  void _applyFilters() {
    context.read<PlayerProvider>().loadPlayers(
      nome: _searchController.text.isEmpty ? null : _searchController.text,
      clube: _selectedClube,
      posicao: _selectedPosicao,
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final playerProvider = context.watch<PlayerProvider>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jogadores'),
        backgroundColor: const Color(0xFF8B1538),
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Barra de busca
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar jogador...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _applyFilters();
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onChanged: (value) {
                setState(() {});
                
                // Cancela o timer anterior se existir
                if (_debounce?.isActive ?? false) _debounce!.cancel();
                
                // Cria novo timer de 500ms
                _debounce = Timer(const Duration(milliseconds: 500), () {
                  _applyFilters();
                });
              },
            ),
          ),
          
          // Filtros
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Clube',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                    ),
                    value: _selectedClube,
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('Todos'),
                      ),
                      ..._clubes.map((clube) {
                        return DropdownMenuItem(
                          value: clube,
                          child: Text(clube),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _selectedClube = value;
                      });
                      _applyFilters();
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
                      _applyFilters();
                    },
                  ),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Lista de jogadores
          Expanded(
            child: playerProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : playerProvider.errorMessage != null
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
                                playerProvider.errorMessage!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.red),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () {
                                  playerProvider.refresh();
                                },
                                child: const Text('Tentar novamente'),
                              ),
                            ],
                          ),
                        ),
                      )
                    : playerProvider.jogadores.isEmpty
                        ? const Center(
                            child: Text('Nenhum jogador encontrado'),
                          )
                        : RefreshIndicator(
                            onRefresh: () => playerProvider.refresh(),
                            child: ListView.builder(
                              itemCount: playerProvider.jogadores.length,
                              itemBuilder: (context, index) {
                                final jogador = playerProvider.jogadores[index];
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
}
