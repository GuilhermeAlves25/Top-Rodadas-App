# Cartola FC Flutter App

Aplicativo Flutter para visualização e comparação de estatísticas do Cartola FC.

## Recursos

- 📊 Dashboard com top jogadores da rodada
- 🔍 Busca e filtros de jogadores
- 📈 Gráficos de evolução de desempenho
- ⚖️ Comparação entre dois jogadores
- 🏆 Rankings por categoria (gols, assistências, defesa, etc.)
- 💾 Cache local para melhor performance

## Pré-requisitos

- Flutter SDK (>= 3.0.0)
- Dart SDK (>= 3.0.0)
- API Java rodando em http://localhost:8080

## Instalação

1. Clone o repositório
2. Instale as dependências:
```bash
flutter pub get
```

3. Configure a URL da API em `lib/services/player_service.dart`:
   - Para Android Emulator: `http://10.0.2.2:8080/api`
   - Para iOS Simulator: `http://localhost:8080/api`
   - Para dispositivo físico: `http://SEU_IP:8080/api`

4. Execute o app:
```bash
flutter run
```

## Estrutura do Projeto

```
lib/
├── models/          # Modelos de dados
├── providers/       # Gerenciamento de estado (Provider)
├── screens/         # Telas do aplicativo
├── services/        # Serviços de API e cache
├── widgets/         # Widgets reutilizáveis
└── main.dart        # Ponto de entrada
```

## Dependências Principais

- **dio**: Cliente HTTP
- **provider**: Gerenciamento de estado
- **fl_chart**: Gráficos
- **shared_preferences**: Armazenamento local
- **cached_network_image**: Cache de imagens

## Telas

1. **Seleção de Clube**: Escolha seu clube favorito
2. **Dashboard**: Visão geral com top 5 da rodada
3. **Lista de Jogadores**: Busca e filtros
4. **Detalhes do Jogador**: Estatísticas completas e gráfico de evolução
5. **Comparação**: Compare dois jogadores lado a lado
6. **Rankings**: Visualize rankings por categoria

## Build para Produção

```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```
