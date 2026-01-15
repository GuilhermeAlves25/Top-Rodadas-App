import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/player_provider.dart';
import 'providers/ranking_provider.dart';
import 'providers/app_provider.dart';
import 'screens/club_selection_screen.dart';
import 'screens/dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()..loadClubeFavorito()),
        ChangeNotifierProvider(create: (_) => PlayerProvider()),
        ChangeNotifierProvider(create: (_) => RankingProvider()),
      ],
      child: MaterialApp(
        title: 'Top Rodadas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8B1538), // Vermelho vinho
            primary: const Color(0xFF8B1538), // Vermelho vinho principal
            secondary: const Color(0xFFA52A4A), // Vermelho vinho mais claro
            surface: Colors.white,
            brightness: Brightness.light,
          ),
          scaffoldBackgroundColor: const Color(0xFFF5F5F5),
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: Color(0xFF8B1538), // Vermelho vinho
            foregroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.white),
          ),
          cardTheme: CardThemeData(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.white,
          ),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color(0xFF8B1538),
            foregroundColor: Colors.white,
          ),
          chipTheme: const ChipThemeData(
            backgroundColor: Color(0xFFFFEBF0),
            selectedColor: Color(0xFF8B1538),
            labelStyle: TextStyle(color: Color(0xFF8B1538)),
          ),
        ),
        home: Consumer<AppProvider>(
          builder: (context, appProvider, _) {
            if (appProvider.clubeFavorito != null && 
                appProvider.clubeFavorito!.isNotEmpty) {
              return const DashboardScreen();
            }
            return const ClubSelectionScreen();
          },
        ),
      ),
    );
  }
}
