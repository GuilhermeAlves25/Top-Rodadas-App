import 'package:flutter/foundation.dart';
import '../services/cache_service.dart';

class AppProvider with ChangeNotifier {
  final CacheService _cacheService = CacheService();
  
  String? _clubeFavorito;
  
  String? get clubeFavorito => _clubeFavorito;
  
  Future<void> loadClubeFavorito() async {
    _clubeFavorito = await _cacheService.getClubeFavorito();
    notifyListeners();
  }
  
  Future<void> setClubeFavorito(String clube) async {
    _clubeFavorito = clube;
    await _cacheService.setClubeFavorito(clube);
    notifyListeners();
  }
  
  Future<void> clearClubeFavorito() async {
    _clubeFavorito = null;
    await _cacheService.setClubeFavorito('');
    notifyListeners();
  }
}
