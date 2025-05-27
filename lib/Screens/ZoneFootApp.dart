import 'package:flutter/material.dart';



class ZoneFootApp extends StatelessWidget {
  const ZoneFootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZoneFoot',
      home: const PremierLeagueScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PremierLeagueScreen extends StatelessWidget {
  const PremierLeagueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFE5F6),
      body: SafeArea(
        child: Column(
          children: [
            Container(
              color: const Color(0xFFD9F0A8),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.menu),
                      Text(
                        'ZoneFoot',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Icon(Icons.settings),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Icon(Icons.sports_soccer, size: 40),
                  const SizedBox(height: 8),
                  const Text(
                    'Premier League',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Championnat d\'Angleterre',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  ToggleButtons(
                    isSelected: const [false, true, false],
                    borderRadius: BorderRadius.circular(30),
                    selectedColor: Colors.white,
                    fillColor: const Color(0xFF6A0DAD),
                    color: Colors.black,
                    children: const [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Résultats'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Classements'),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Text('Buteurs'),
                      ),
                    ],
                    onPressed: (index) {},
                  ),
                  const SizedBox(height: 20),
                  _buildTable(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTable() {
    final teams = [
      ['Liverpool', 'assets/liverpool.png', '09'],
      ['Manchester City', 'assets/mancity.png', '09'],
      ['Arsenal', 'assets/arsenal.png', '06'],
      ['Manchester United', 'assets/manutd.png', '04'],
      ['Chelsea', 'assets/chelsea.png', '04'],
      ['Tottenham', 'assets/tottenham.png', '02'],
      ['Bournemouth', 'assets/bournemouth.png', '02'],
      ['Norwich', 'assets/norwich.png', '01'],
    ];

    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF4A0E6F),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: const [
              Expanded(flex: 2, child: Text('#', style: TextStyle(color: Colors.white))),
              Expanded(flex: 6, child: Text('Equipes', style: TextStyle(color: Colors.white))),
              Expanded(flex: 1, child: Text('J', style: TextStyle(color: Colors.white))),
              Expanded(flex: 1, child: Text('Pts', style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
        const SizedBox(height: 10),
        ...teams.asMap().entries.map((entry) {
          final index = entry.key + 1;
          final team = entry.value;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: Row(
              children: [
                Expanded(flex: 2, child: Text(index.toString())),
                Expanded(
                  flex: 6,
                  child: Row(
                    children: [
                      Image.asset(team[1], width: 24, height: 24),
                      const SizedBox(width: 8),
                      Text(team[0], overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                const Expanded(flex: 1, child: Text('03')),
                Expanded(flex: 1, child: Text(team[2])),
              ],
            ),
          );
        }),
      ],
     );
  }
}
