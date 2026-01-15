# Top Rodadas FC - Sistema de Fantasy Football

![Top Rodadas FC](flutter_app/assets/images/icon.png)

## 📋 Índice
- [Visão Geral](#visão-geral)
- [Arquitetura do Sistema](#arquitetura-do-sistema)
- [Backend - API REST Java](#backend---api-rest-java)
- [Frontend - Flutter](#frontend---flutter)
- [Instalação e Execução](#instalação-e-execução)
- [Fluxo de Dados](#fluxo-de-dados)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)

---

## 🎯 Visão Geral

**Top Rodadas FC** é um aplicativo mobile de fantasy football que permite aos usuários acompanhar estatísticas, rankings e comparações de jogadores através de uma interface moderna e intuitiva.

### Funcionalidades Principais
- ✅ Visualização de rankings por rodada
- ✅ Filtros avançados (nome, clube, posição)
- ✅ Comparação entre jogadores
- ✅ Detalhes completos de jogadores com gráficos
- ✅ Rankings especializados (artilheiros, assistências, defesa, goleiros)
- ✅ Seleção de clube favorito
- ✅ Interface responsiva com tema vermelho vinho

---

## 🏗️ Arquitetura do Sistema

```
┌─────────────────────────────────────────────────────────────┐
│                     DISPOSITIVO MÓVEL                        │
│  ┌───────────────────────────────────────────────────────┐  │
│  │          Flutter App (Dart)                           │  │
│  │  ┌─────────────┐  ┌─────────────┐  ┌──────────────┐  │  │
│  │  │  Screens    │  │  Providers  │  │   Widgets    │  │  │
│  │  └─────────────┘  └─────────────┘  └──────────────┘  │  │
│  │         │                │                 │          │  │
│  │         └────────────────┴─────────────────┘          │  │
│  │                       │                                │  │
│  │                  ┌────▼─────┐                         │  │
│  │                  │ Services │                         │  │
│  │                  │   (Dio)  │                         │  │
│  │                  └────┬─────┘                         │  │
│  └───────────────────────┼────────────────────────────────┘  │
└─────────────────────────┼─────────────────────────────────┘
                          │ HTTP/JSON
                          │
┌─────────────────────────▼─────────────────────────────────┐
│                    SERVIDOR LOCAL                          │
│  ┌─────────────────────────────────────────────────────┐  │
│  │        Spring Boot API REST (Java 21)               │  │
│  │  ┌──────────┐  ┌───────────┐  ┌─────────────────┐  │  │
│  │  │Controller│◄─┤  Service  │◄─┤   Repository    │  │  │
│  │  └──────────┘  └───────────┘  └─────────────────┘  │  │
│  │       │              │                  │           │  │
│  │       │              │         ┌────────▼────────┐  │  │
│  │       │              │         │  H2 Database    │  │  │
│  │       │              │         │  (In-Memory)    │  │  │
│  │       │              │         └─────────────────┘  │  │
│  │       │              │                  ▲           │  │
│  │       │         ┌────▼──────────────────┘           │  │
│  │       │         │ DataLoaderService                 │  │
│  │       │         │ (ETL - JSON/CSV)                  │  │
│  │       │         └───────────────────────────────────┘  │
│  └─────────────────────────────────────────────────────┘  │
└────────────────────────────────────────────────────────────┘
```

---

## 🔧 Backend - API REST Java

### Estrutura de Diretórios
```
src/main/
├── java/com/cartola/
│   ├── controller/
│   │   └── CartolaController.java      # Endpoints REST
│   ├── service/
│   │   ├── CartolaService.java         # Lógica de negócio
│   │   └── DataLoaderService.java      # Carregamento de dados
│   ├── repository/
│   │   ├── JogadorRepository.java      # Queries JPA
│   │   ├── RodadaRepository.java
│   │   └── ClubeRepository.java
│   ├── model/
│   │   ├── Jogador.java                # Entidade jogador
│   │   ├── Rodada.java                 # Entidade rodada
│   │   └── Clube.java                  # Entidade clube
│   └── dto/
│       ├── JogadorDTO.java             # Data Transfer Objects
│       ├── JogadorDetalheDTO.java
│       └── ComparacaoDTO.java
└── resources/
    ├── application.properties          # Configurações
    ├── clubes.csv                      # Dados dos clubes
    └── jogadores_rodadas.json          # Dados dos jogadores
```

### Endpoints Disponíveis

#### 📊 Jogadores
```http
GET /api/jogadores
Query params: nome, clube, posicao, limite
Retorna: Lista de jogadores com filtros opcionais
```

```http
GET /api/jogadores/{id}
Retorna: Detalhes completos do jogador
```

#### 🏆 Rankings
```http
GET /api/ranking/rodada
Query params: rodada, posicao, limite
Retorna: Top jogadores de uma rodada específica
```

```http
GET /api/ranking/geral
Query params: posicao, limite
Retorna: Ranking geral de todos os jogadores
```

#### ⚽ Scouts
```http
GET /api/scouts/ataque/top-gols
Query params: limite (padrão: 20)
Retorna: Top artilheiros
```

```http
GET /api/scouts/ataque/top-assistencias
Query params: limite (padrão: 20)
Retorna: Top assistências
```

```http
GET /api/scouts/defesa/top-desarmes
Query params: limite (padrão: 20)
Retorna: Top desarmes
```

```http
GET /api/scouts/goleiros/top-defesas-dificeis
Query params: limite (padrão: 20)
Retorna: Top defesas difíceis
```

#### 🔄 Comparação
```http
GET /api/comparacao
Query params: jogador1Id, jogador2Id
Retorna: Comparação detalhada entre dois jogadores
```

#### 🏅 Clubes
```http
GET /api/clubes
Retorna: Lista de todos os clubes
```

#### 📈 Estatísticas
```http
GET /api/estatisticas/resumo
Retorna: Resumo estatístico do sistema
```

### Tecnologias Backend
- **Java 21** (LTS)
- **Spring Boot 3.2.1** - Framework principal
- **Spring Data JPA** - Persistência de dados
- **Hibernate** - ORM
- **H2 Database** - Banco em memória
- **Lombok 1.18.34** - Redução de boilerplate
- **Maven 3.9.12** - Gerenciamento de dependências

### Processo ETL
O `DataLoaderService` executa ao iniciar a aplicação:
1. **Carrega clubes** do arquivo `clubes.csv` (20 clubes)
2. **Carrega jogadores e rodadas** do arquivo `jogadores_rodadas.json` (980 jogadores, 28.589 rodadas)
3. **Calcula deltas** de pontuação entre rodadas consecutivas
4. **Persiste no H2** em memória para queries rápidas

### Exemplo de Resposta JSON
```json
{
  "id": 1,
  "apelido": "Neymar",
  "clube": "PSG",
  "posicao": "ATA",
  "pontuacaoTotal": 245.7,
  "gols": 12,
  "assistencias": 8,
  "status": "PROVAVEL"
}
```

---

## 📱 Frontend - Flutter

### Estrutura de Diretórios
```
lib/
├── main.dart                           # Ponto de entrada
├── models/
│   ├── jogador.dart                    # Model de jogador
│   ├── jogador_detalhe.dart            # Model detalhado
│   ├── rodada.dart                     # Model de rodada
│   ├── clube.dart                      # Model de clube
│   └── comparacao.dart                 # Model de comparação
├── providers/
│   ├── app_provider.dart               # Estado global
│   ├── player_provider.dart            # Estado de jogadores
│   └── ranking_provider.dart           # Estado de rankings
├── screens/
│   ├── dashboard_screen.dart           # Tela principal
│   ├── player_list_screen.dart         # Lista de jogadores
│   ├── player_detail_screen.dart       # Detalhes do jogador
│   ├── ranking_screen.dart             # Rankings por categoria
│   ├── comparison_screen.dart          # Comparação de jogadores
│   ├── scout_ranking_screen.dart       # Rankings especializados
│   └── club_selection_screen.dart      # Seleção de clube
├── services/
│   ├── player_service.dart             # HTTP client (Dio)
│   └── cache_service.dart              # Cache local
└── widgets/
    └── player_card.dart                # Card reutilizável
```

### Telas do Aplicativo

#### 1️⃣ Club Selection Screen
- Primeira tela ao abrir o app
- Seleção de clube favorito (dropdown)
- Persistência usando SharedPreferences

#### 2️⃣ Dashboard Screen
- Top 5 jogadores da rodada
- Filtros por rodada e posição
- Cards de atalho (Artilharia, Assistências, Defesa, Goleiros)
- BottomNavigationBar (Início, Jogadores, Rankings)

#### 3️⃣ Player List Screen
- Busca por nome (debounce 500ms)
- Filtros por clube e posição
- Lista infinita de jogadores
- Navegação para detalhes

#### 4️⃣ Player Detail Screen
- Informações completas do jogador
- Gráfico de pontuação por rodada (fl_chart)
- Histórico de rodadas
- Scouts detalhados

#### 5️⃣ Ranking Screen
- Tabs: Por Rodada, Artilharia, Assistências
- Filtros por posição
- Top jogadores por categoria

#### 6️⃣ Comparison Screen
- Seleção de 2 jogadores
- Comparação lado a lado
- Estatísticas detalhadas

#### 7️⃣ Scout Ranking Screen
- Rankings especializados (top 20)
- Categorias: Gols, Assistências, Desarmes, Defesas

### State Management - Provider
```dart
// AppProvider - Estado global
- clubeFavorito (SharedPreferences)
- tema, configurações

// PlayerProvider - Jogadores
- Lista de jogadores
- Filtros ativos
- Loading state

// RankingProvider - Rankings
- Top 5 da rodada
- Filtros de rodada/posição
- Cache de rankings
```

### HTTP Client - Dio
```dart
PlayerService() {
  _dio = Dio(BaseOptions(
    baseUrl: 'http://10.137.253.155:8080/api',
    headers: {
      'Cache-Control': 'no-cache, no-store, must-revalidate',
      'Pragma': 'no-cache',
      'Expires': '0',
    },
  ));
}
```

### Tecnologias Frontend
- **Flutter 3.35.4** - Framework UI
- **Dart 3.9.2** - Linguagem
- **Provider 6.1.1** - Gerenciamento de estado
- **Dio 5.4.0** - HTTP client
- **fl_chart 0.65.0** - Gráficos
- **cached_network_image 3.3.1** - Cache de imagens
- **shared_preferences 2.2.2** - Persistência local
- **intl 0.18.1** - Formatação de datas/números

### Tema e Cores
```dart
Color(0xFF8B1538)  // Vermelho vinho (principal)
Color(0xFFA52A4A)  // Vermelho vinho claro (secundária)
Color(0xFFFFEBF0)  // Rosa claro (backgrounds)
Color(0xFFF5F5F5)  // Cinza claro (scaffold)
```

---

## 🚀 Instalação e Execução

### Pré-requisitos
- Java 21 (JDK)
- Maven 3.9+
- Flutter 3.0+
- Android Studio / VS Code
- Dispositivo Android ou Emulador

### Backend - Passo a Passo

1. **Clone o repositório**
```bash
git clone <url-do-repositorio>
cd "projeto final programacao para dispositivos moveis"
```

2. **Execute o backend**
```bash
mvn spring-boot:run
```

3. **Verifique se está rodando**
```bash
# Deve retornar JSON com jogadores
curl http://localhost:8080/api/jogadores
```

4. **Configure o firewall** (Windows)
```powershell
netsh advfirewall firewall add rule name="Cartola Backend" dir=in action=allow protocol=TCP localport=8080
```

### Frontend - Passo a Passo

1. **Navegue para pasta do Flutter**
```bash
cd flutter_app
```

2. **Configure o IP do backend**
Edite `lib/services/player_service.dart`:
```dart
// Troque pelo IP do seu computador na rede local
static const String baseUrl = 'http://SEU_IP:8080/api';
```

3. **Instale dependências**
```bash
flutter pub get
```

4. **Execute em modo debug** (para desenvolvimento)
```bash
flutter run
```

5. **Compile APK** (para distribuição)
```bash
flutter build apk --release
```

6. **Instale no dispositivo**
- APK gerado em: `build/app/outputs/flutter-apk/app-release.apk`
- Transfira para o celular e instale

### Configuração de Rede

#### Hotspot do Celular (Recomendado para apresentações)
1. Ative o hotspot no celular
2. Conecte o notebook no hotspot
3. Descubra o IP do notebook:
```powershell
ipconfig
# Anote o IP da seção "Wi-Fi"
```
4. Atualize o IP no `player_service.dart`
5. Recompile o APK
6. Instale no celular

#### WiFi da Faculdade/Casa
1. Conecte notebook e celular na mesma rede
2. Configure firewall para permitir porta 8080
3. Use IP local do notebook (ex: 192.168.1.100)

---

## 🔄 Fluxo de Dados

### 1. Inicialização do Sistema

```
Backend Startup:
1. Spring Boot inicia
2. DataLoaderService é executado
3. Carrega clubes.csv → Banco H2
4. Carrega jogadores_rodadas.json → Banco H2
5. Calcula deltas de pontuação
6. API fica disponível em localhost:8080
```

```
Frontend Startup:
1. Flutter app inicia
2. Verifica clube favorito (SharedPreferences)
3. Se não existe → ClubSelectionScreen
4. Se existe → DashboardScreen
5. Carrega top 5 da rodada via API
```

### 2. Fluxo de uma Requisição

```
[User Action] → [Screen] → [Provider] → [Service] → [Dio HTTP]
                                                         ↓
[Backend Response] ← [JSON Parse] ← [HTTP Response] ←──┘
       ↓
[Provider atualiza estado]
       ↓
[Screen rebuilda UI]
```

### 3. Exemplo Prático - Buscar Jogadores

```dart
// 1. Usuário digita no campo de busca
onChanged: (value) {
  _debounceTimer?.cancel();
  _debounceTimer = Timer(Duration(milliseconds: 500), () {
    context.read<PlayerProvider>().loadPlayers(nome: value);
  });
}

// 2. Provider chama o Service
class PlayerProvider {
  Future<void> loadPlayers({String? nome}) async {
    _isLoading = true;
    notifyListeners();
    
    final jogadores = await PlayerService().getJogadores(
      nome: nome,
    );
    
    _jogadores = jogadores;
    _isLoading = false;
    notifyListeners();
  }
}

// 3. Service faz requisição HTTP
Future<List<Jogador>> getJogadores({String? nome}) async {
  final response = await _dio.get('/jogadores', 
    queryParameters: {'nome': nome}
  );
  return (response.data as List)
    .map((json) => Jogador.fromJson(json))
    .toList();
}

// 4. Backend processa (CartolaController)
@GetMapping("/jogadores")
public List<JogadorDTO> listarJogadores(
  @RequestParam(required = false) String nome
) {
  return service.buscarJogadores(nome, null, null, null);
}

// 5. Repository executa query
@Query("SELECT DISTINCT j FROM Jogador j " +
       "WHERE (:nome IS NULL OR LOWER(j.apelido) LIKE %:nome%)")
List<Jogador> findByFiltros(@Param("nome") String nome);

// 6. Resposta volta em JSON
// 7. Flutter atualiza UI automaticamente
```

---

## 📊 Dados do Sistema

### Volume de Dados
- **980 jogadores** únicos
- **28.589 rodadas** registradas  
- **20 clubes** brasileiros
- **6 posições** (GOL, LAT, ZAG, MEI, ATA, TEC)

### Campos de Jogador
```java
class Jogador {
  Long id;
  String apelido;
  String nome;
  String clube;
  String posicao;
  Double pontuacaoTotal;
  Integer gols;
  Integer assistencias;
  // ... scouts detalhados
}
```

### Scouts Disponíveis
- **Ataque**: Gols, assistências, finalizações
- **Defesa**: Desarmes, interceptações, bloqueios
- **Goleiros**: Defesas difíceis, defesas, gols sofridos
- **Disciplina**: Cartões amarelos/vermelhos, faltas
- **Outros**: Passes errados, perdas de posse

---

## 🎨 Design System

### Paleta de Cores
| Cor | Hex | Uso |
|-----|-----|-----|
| Vermelho Vinho | `#8B1538` | AppBar, botões, destaques |
| Vermelho Claro | `#A52A4A` | Secundária, variações |
| Rosa Claro | `#FFEBF0` | Backgrounds, cards suaves |
| Cinza Claro | `#F5F5F5` | Scaffold background |
| Branco | `#FFFFFF` | Cards, textos em fundos escuros |

### Tipografia
- **Títulos**: Bold, 18-24px
- **Subtítulos**: SemiBold, 14-16px
- **Corpo**: Regular, 12-14px
- **Fonte**: Roboto (padrão Material)

### Componentes Customizados
- **PlayerCard**: Card reutilizável de jogador com avatar circular
- **AppBar**: Vermelho vinho com ícones brancos
- **BottomNavigationBar**: Vermelho vinho quando selecionado
- **ElevatedButton**: Vermelho vinho com texto branco

---

## 📝 Logs e Debugging

### Backend - Logs
```properties
# application.properties
logging.level.com.cartola=DEBUG
spring.jpa.show-sql=true
```

### Frontend - Debug
```dart
// Habilitar logs do Dio
_dio.interceptors.add(LogInterceptor(
  responseBody: true,
  requestBody: true,
));
```

---

## 🔐 Segurança e Performance

### Backend
- ✅ CORS habilitado para desenvolvimento
- ✅ Validação de parâmetros
- ✅ Queries otimizadas com índices
- ✅ Connection pool configurado

### Frontend
- ✅ Cache HTTP desabilitado (no-cache headers)
- ✅ Debounce em buscas (500ms)
- ✅ Lazy loading de imagens
- ✅ Persistência local (SharedPreferences)

---

## 🐛 Troubleshooting

### Problema: App não conecta ao backend
**Solução:**
1. Verifique se backend está rodando (`curl http://localhost:8080/api/jogadores`)
2. Confirme que o IP está correto no `player_service.dart`
3. Verifique firewall (porta 8080 aberta)
4. Teste no navegador do celular: `http://IP:8080/api/jogadores`

### Problema: Filtros não funcionam
**Solução:**
1. Verifique headers no-cache no Dio
2. Limpe cache do app (desinstale e reinstale)
3. Confirme que backend retorna dados corretos

### Problema: APK não instala
**Solução:**
1. Habilite "Fontes desconhecidas" no Android
2. Desinstale versão anterior
3. Recompile com `flutter clean && flutter build apk --release`

---

## 👨‍💻 Autores

**Backend (Java/Spring Boot):**
- Desenvolvido como API REST completa
- 15 endpoints implementados
- ETL de dados JSON/CSV

**Frontend (Flutter):**
- 7 telas funcionais
- State management com Provider
- Interface Material Design customizada

---

## 📄 Licença

Este projeto foi desenvolvido para fins acadêmicos como trabalho final da disciplina de **Programação para Dispositivos Móveis**.

---

## 🎓 Tecnologias Aprendidas

### Backend
- ✅ Spring Boot e ecossistema Spring
- ✅ JPA/Hibernate para ORM
- ✅ REST API design
- ✅ ETL de dados (JSON/CSV)
- ✅ Queries personalizadas JPQL

### Frontend
- ✅ Flutter framework completo
- ✅ State management (Provider)
- ✅ HTTP client (Dio)
- ✅ Navegação entre telas
- ✅ Gráficos com fl_chart
- ✅ Cache e persistência local

### DevOps
- ✅ Maven para build
- ✅ Gradle para Android
- ✅ Hot reload durante desenvolvimento
- ✅ Release builds otimizados

---

**🎉 Projeto Completo - Top Rodadas FC**

*Desenvolvido com ❤️ usando Java, Spring Boot, Flutter e Dart*
