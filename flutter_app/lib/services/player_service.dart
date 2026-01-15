import 'package:dio/dio.dart';
import '../models/jogador.dart';
import '../models/jogador_detalhe.dart';
import '../models/rodada.dart';
import '../models/comparacao.dart';
import 'cache_service.dart';

class PlayerService {
  late final Dio _dio;
  final CacheService _cacheService = CacheService();
  
  // Configure o IP do seu backend aqui (ou use localhost se estiver no emulador)
  // static const String baseUrl = 'http://10.0.2.2:8080/api'; // Para Android Emulator
  // static const String baseUrl = 'http://localhost:8080/api'; // Para iOS Simulator
  // static const String baseUrl = 'http://192.168.18.6:8080/api'; // Para WiFi de casa
  static const String baseUrl = 'http://10.207.86.155:8080/api'; // Para hotspot do celular (IFPI)
  
  PlayerService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Pragma': 'no-cache',
        'Expires': '0',
      },
    ));
    
    // Interceptor para logging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }
  
  // GET /jogadores
  Future<List<Jogador>> getPlayers({
    String? nome,
    String? clube,
    String? posicao,
    bool useCache = true,
  }) async {
    try {
      // SEMPRE buscar da API
      final queryParams = <String, dynamic>{};
      if (nome != null && nome.isNotEmpty) queryParams['nome'] = nome;
      if (clube != null && clube.isNotEmpty) queryParams['clube'] = clube;
      if (posicao != null && posicao.isNotEmpty) queryParams['posicao'] = posicao;
      
      final response = await _dio.get('/jogadores', queryParameters: queryParams);
      final List<dynamic> data = response.data;
      return data.map((json) => Jogador.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
  
  // GET /jogadores/{id}
  Future<JogadorDetalhe> getPlayerDetails(int id) async {
    try {
      final response = await _dio.get('/jogadores/$id');
      return JogadorDetalhe.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // GET /clubes
  Future<List<String>> getClubes() async {
    try {
      final response = await _dio.get('/clubes');
      final List<dynamic> data = response.data;
      return data.cast<String>();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // GET /jogadores/{id}/rodadas
  Future<List<Rodada>> getPlayerHistory(int id, {int? limite}) async {
    try {
      final response = await _dio.get('/jogadores/$id/rodadas', queryParameters: {
        if (limite != null) 'limite': limite,
      });
      
      final List<dynamic> data = response.data;
      return data.map((json) => Rodada.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // GET /ranking/rodada
  Future<List<Jogador>> getRanking({
    required int rodada,
    String? posicao,
    int limite = 10,
  }) async {
    try {
      final response = await _dio.get('/ranking/rodada', queryParameters: {
        'rodada': rodada,
        if (posicao != null) 'posicao': posicao,
        'limite': limite,
      });
      
      final List<dynamic> data = response.data;
      return data.map((json) => Jogador.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // GET /comparacao
  Future<Comparacao> comparePlayer(int id1, int id2) async {
    try {
      final response = await _dio.get('/comparacao', queryParameters: {
        'id1': id1,
        'id2': id2,
      });
      
      return Comparacao.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // GET /scouts/ataque/top-gols
  Future<List<Jogador>> getTopScorers({
    int? rodada,
    String? clube,
    String? posicao,
    int limite = 10,
  }) async {
    try {
      final response = await _dio.get('/scouts/ataque/top-gols', queryParameters: {
        if (rodada != null) 'rodada': rodada,
        if (clube != null) 'clube': clube,
        if (posicao != null) 'posicao': posicao,
        'limite': limite,
      });
      
      final List<dynamic> data = response.data;
      return data.map((json) => Jogador.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // GET /scouts/ataque/top-assistencias
  Future<List<Jogador>> getTopAssists({
    int? rodada,
    String? clube,
    String? posicao,
    int limite = 10,
  }) async {
    try {
      final response = await _dio.get('/scouts/ataque/top-assistencias', queryParameters: {
        if (rodada != null) 'rodada': rodada,
        if (clube != null) 'clube': clube,
        if (posicao != null) 'posicao': posicao,
        'limite': limite,
      });
      
      final List<dynamic> data = response.data;
      return data.map((json) => Jogador.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // GET /scouts/defesa/top-desarmes
  Future<List<Jogador>> getTopTackles({
    int? rodada,
    String? clube,
    String? posicao,
    int limite = 10,
  }) async {
    try {
      final response = await _dio.get('/scouts/defesa/top-desarmes', queryParameters: {
        if (rodada != null) 'rodada': rodada,
        if (clube != null) 'clube': clube,
        if (posicao != null) 'posicao': posicao,
        'limite': limite,
      });
      
      final List<dynamic> data = response.data;
      return data.map((json) => Jogador.fromJson(json)).toList();
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // GET /estatisticas/clube/{clube}
  Future<Map<String, dynamic>> getClubStats(String clube) async {
    try {
      final response = await _dio.get('/estatisticas/clube/$clube');
      return response.data;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
  
  // GET /scouts/ataque/top-gols
  Future<List<Jogador>> getTopGols({int limite = 20}) async {
    try {
      final response = await _dio.get('/scouts/ataque/top-gols', queryParameters: {'limite': limite});
      final List<dynamic> data = response.data;
      return data.map((json) => Jogador.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
  
  // GET /scouts/ataque/top-assistencias
  Future<List<Jogador>> getTopAssistencias({int limite = 20}) async {
    try {
      final response = await _dio.get('/scouts/ataque/top-assistencias', queryParameters: {'limite': limite});
      final List<dynamic> data = response.data;
      return data.map((json) => Jogador.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
  
  // GET /scouts/defesa/top-desarmes
  Future<List<Jogador>> getTopDesarmes({int limite = 20}) async {
    try {
      final response = await _dio.get('/scouts/defesa/top-desarmes', queryParameters: {'limite': limite});
      final List<dynamic> data = response.data;
      return data.map((json) => Jogador.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
  
  // GET /scouts/goleiros/top-defesas-dificeis
  Future<List<Jogador>> getTopDefesasDificeis({int limite = 20}) async {
    try {
      final response = await _dio.get('/scouts/goleiros/top-defesas-dificeis', queryParameters: {'limite': limite});
      final List<dynamic> data = response.data;
      return data.map((json) => Jogador.fromJson(json)).toList();
    } catch (e) {
      rethrow;
    }
  }
  
  String _handleError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout) {
      return 'Tempo de conexão esgotado. Verifique sua internet.';
    } else if (e.type == DioExceptionType.connectionError) {
      return 'Erro de conexão. Verifique se o servidor está rodando.';
    } else if (e.response != null) {
      return 'Erro ${e.response!.statusCode}: ${e.response!.statusMessage}';
    }
    return 'Erro desconhecido: ${e.message}';
  }
}
