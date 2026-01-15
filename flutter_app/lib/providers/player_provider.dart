import 'package:flutter/foundation.dart';
import '../models/jogador.dart';
import '../services/player_service.dart';

class PlayerProvider with ChangeNotifier {
  final PlayerService _playerService = PlayerService();
  
  List<Jogador> _jogadores = [];
  bool _isLoading = false;
  String? _errorMessage;
  
  List<Jogador> get jogadores => _jogadores;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  
  Future<void> loadPlayers({String? nome, String? clube, String? posicao}) async {
    _isLoading = true;
    _errorMessage = null;
    _jogadores = []; // LIMPA A LISTA ANTES
    notifyListeners(); // NOTIFICA QUE ESTÁ VAZIO
    
    try {
      _jogadores = await _playerService.getPlayers(
        nome: nome,
        clube: clube,
        posicao: posicao,
        useCache: false,
      );
    } catch (e) {
      _errorMessage = e.toString();
      _jogadores = []; // GARANTE QUE FICA VAZIO EM CASO DE ERRO
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  Future<void> refresh() async {
    await loadPlayers();
  }
}
