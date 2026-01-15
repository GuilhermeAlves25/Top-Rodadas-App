import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static const String _keyJogadores = 'cached_jogadores';
  static const String _keyClubesFavoritos = 'clube_favorito';
  static const String _keyLastUpdate = 'last_update';
  
  // Cache de jogadores
  Future<void> saveJogadores(List<Map<String, dynamic>> jogadores) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(jogadores);
    await prefs.setString(_keyJogadores, jsonString);
    await prefs.setString(_keyLastUpdate, DateTime.now().toIso8601String());
  }
  
  Future<List<Map<String, dynamic>>?> getJogadores() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_keyJogadores);
    
    if (jsonString == null) return null;
    
    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.cast<Map<String, dynamic>>();
  }
  
  Future<DateTime?> getLastUpdateTime() async {
    final prefs = await SharedPreferences.getInstance();
    final dateString = prefs.getString(_keyLastUpdate);
    
    if (dateString == null) return null;
    return DateTime.parse(dateString);
  }
  
  // Clube favorito
  Future<void> setClubeFavorito(String clube) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyClubesFavoritos, clube);
  }
  
  Future<String?> getClubeFavorito() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyClubesFavoritos);
  }
  
  // Limpar cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyJogadores);
    await prefs.remove(_keyLastUpdate);
  }
  
  // Verificar se cache está válido (menos de 1 hora)
  Future<bool> isCacheValid() async {
    final lastUpdate = await getLastUpdateTime();
    if (lastUpdate == null) return false;
    
    final difference = DateTime.now().difference(lastUpdate);
    return difference.inHours < 1;
  }
}
