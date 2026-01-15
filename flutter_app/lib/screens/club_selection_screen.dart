import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import 'dashboard_screen.dart';

class ClubSelectionScreen extends StatefulWidget {
  const ClubSelectionScreen({Key? key}) : super(key: key);
  
  @override
  State<ClubSelectionScreen> createState() => _ClubSelectionScreenState();
}

class _ClubSelectionScreenState extends State<ClubSelectionScreen> {
  final List<String> _clubes = [
    'Flamengo',
    'Botafogo',
    'Palmeiras',
    'São Paulo',
    'Corinthians',
    'Vasco',
    'Fluminense',
    'Internacional',
    'Atlético-MG',
    'Grêmio',
    'Cruzeiro',
    'Bahia',
    'Santos',
    'Athletico-PR',
    'Fortaleza',
    'Bragantino',
    'Cuiabá',
    'Goiás',
    'Coritiba',
    'América-MG',
  ];
  
  String? _selectedClube;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Top Rodadas FC'),
        backgroundColor: const Color(0xFF8B1538),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.sports_soccer,
              size: 80,
              color: Color(0xFF8B1538),
            ),
            const SizedBox(height: 24),
            const Text(
              'Bem-vindo ao Top Rodadas FC',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Selecione seu clube do coração',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: 'Clube',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                prefixIcon: const Icon(Icons.shield),
              ),
              value: _selectedClube,
              items: _clubes.map((clube) {
                return DropdownMenuItem(
                  value: clube,
                  child: Text(clube),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedClube = value;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _selectedClube == null ? null : () {
                context.read<AppProvider>().setClubeFavorito(_selectedClube!);
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B1538),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Continuar',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => const DashboardScreen(),
                  ),
                );
              },
              child: const Text('Pular'),
            ),
          ],
        ),
      ),
    );
  }
}
