import 'package:flutter/foundation.dart';
import '../models/jogador.dart';
import '../services/player_service.dart';

class RankingProvider with ChangeNotifier {
  final PlayerService _playerService = PlayerService();
  
  List<Jogador> _ranking = [];
  bool _isLoading = false;
  String? _errorMessage;
  int _currentRodada = 1;
  String? _currentPosicao;
  
  List<Jogador> get ranking => _ranking;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  int get currentRodada => _currentRodada;
  String? get currentPosicao => _currentPosicao;
  
  Future<void> loadRanking({required int rodada, String? posicao, int limite = 10}) async {
    _isLoading = true;
    _errorMessage = null;
    _currentRodada = rodada;
    _currentPosicao = posicao;
    notifyListeners();
    
    try {
      _ranking = await _playerService.getRanking(
        rodada: rodada,
        posicao: posicao,
        limite: limite,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> loadTopScorers({int? rodada, String? clube, int limite = 10}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _ranking = await _playerService.getTopScorers(
        rodada: rodada,
        clube: clube,
        limite: limite,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> loadTopAssists({int? rodada, String? clube, int limite = 10}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      _ranking = await _playerService.getTopAssists(
        rodada: rodada,
        clube: clube,
        limite: limite,
      );
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
