import 'package:flutter/material.dart';
import '../models/jogador.dart';
import '../services/player_service.dart';
import '../widgets/player_card.dart';
import 'player_detail_screen.dart';

class ScoutRankingScreen extends StatefulWidget {
  final String title;
  final String scoutType; // 'gols', 'assistencias', 'desarmes', 'defesas'
  
  const ScoutRankingScreen({
    Key? key,
    required this.title,
    required this.scoutType,
  }) : super(key: key);
  
  @override
  State<ScoutRankingScreen> createState() => _ScoutRankingScreenState();
}

class _ScoutRankingScreenState extends State<ScoutRankingScreen> {
  final PlayerService _playerService = PlayerService();
  List<Jogador> _jogadores = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _limite = 20;
  
  @override
  void initState() {
    super.initState();
    _loadRanking();
  }
  
  Future<void> _loadRanking() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      List<Jogador> jogadores;
      
      switch (widget.scoutType) {
        case 'gols':
          jogadores = await _playerService.getTopGols(limite: _limite);
          break;
        case 'assistencias':
          jogadores = await _playerService.getTopAssistencias(limite: _limite);
          break;
        case 'desarmes':
          jogadores = await _playerService.getTopDesarmes(limite: _limite);
          break;
        case 'defesas':
          jogadores = await _playerService.getTopDefesasDificeis(limite: _limite);
          break;
        default:
          jogadores = [];
      }
      
      setState(() {
        _jogadores = jogadores;
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
        title: Text(widget.title),
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
                        const Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _errorMessage!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadRanking,
                          child: const Text('Tentar novamente'),
                        ),
                      ],
                    ),
                  ),
                )
              : _jogadores.isEmpty
                  ? const Center(
                      child: Text('Nenhum jogador encontrado'),
                    )
                  : RefreshIndicator(
                      onRefresh: _loadRanking,
                      child: ListView.builder(
                        itemCount: _jogadores.length,
                        itemBuilder: (context, index) {
                          final jogador = _jogadores[index];
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
    );
  }
}
