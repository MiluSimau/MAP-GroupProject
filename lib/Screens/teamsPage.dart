import 'package:flutter/material.dart';
import 'TeamRegistrationPage.dart';
import 'teamBackground.dart';

class TeamsPage extends StatelessWidget {
  // Sample data for team logos and names
  final List<Map<String, String>> teams = [
    {'name': 'Old Boys', 'logo': 'assets/old_boys.png'},
    {'name': 'Spartans', 'logo': 'assets/spartans.png'},
    {'name': 'Pirates', 'logo': 'assets/pirates.png'},
    {'name': 'Red Devils', 'logo': 'assets/reddevils.png'},
    {'name': 'Saints', 'logo': 'assets/saints.png'},
    {'name': 'Vikings', 'logo': 'assets/vikings.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Logo and search
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo
                  Row(
                    children: [
                      Image.asset(
                        'assets/logo.png', // Replace with your logo asset
                        height: 40,
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for team...',
                      prefixIcon: Icon(Icons.search, color: Colors.redAccent),
                      filled: true,
                      fillColor: Colors.grey[100],
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  // Filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChipWidget(label: 'ALL', selected: true),
                        FilterChipWidget(label: 'MENS'),
                        FilterChipWidget(label: 'WOMENS'),
                        FilterChipWidget(label: 'UNDER 12'),
                        FilterChipWidget(label: 'UNDER 18'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Teams grid
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: teams.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1,
                  ),
itemBuilder: (context, index) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TeamPage()),
      );
    },
    child: Card(
      elevation: 0,
      color: Colors.grey[100],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              teams[index]['logo']!,
              height: 60,
            ),
            SizedBox(height: 8),
            Text(
              teams[index]['name']!,
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    ),
  );
},
                ),
              ),
            ),
          ],
        ),
      ),
      // Floating action button in the center of bottom nav
      floatingActionButton: FloatingActionButton(
        onPressed: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (context) =>  TeamRegistrationPage()),
          );
        },
        backgroundColor: Colors.redAccent,
        child: Icon(Icons.add, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
 
    );
  }
}

// Custom Filter Chip Widget
class FilterChipWidget extends StatelessWidget {
  final String label;
  final bool selected;

  const FilterChipWidget({required this.label, this.selected = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        selectedColor: Colors.redAccent,
        backgroundColor: Colors.grey[200],
        labelStyle: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w500,
        ),
        onSelected: (_) {},
      ),
    );
  }
}