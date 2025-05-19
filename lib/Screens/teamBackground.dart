import 'package:flutter/material.dart';
import 'package:hockey_app/Screens/PlayerScreen.dart';
import 'PlayerRegistration.dart';

class TeamPage extends StatelessWidget {
  // Sample data for grid items
  final List<Map<String, String>> members = [
    {"role": "Coach", "name": "Brando"},
    {"role": "#1 GK", "name": "Van Brille"},
    {"role": "#2 GK", "name": "Shitalonga"},
    {"role": "#3 RB", "name": "James"},
    {"role": "#4 RB", "name": "Seibeb"},
    {"role": "#5 CB", "name": "Soondorvelt"},
    {"role": "#6 CB", "name": "Hond"},
    {"role": "#7 LB", "name": "Lamar"},
    {"role": "#8 LB", "name": "Rihene"},
    {"role": "#9 RM", "name": "Diergaardt"},
    {"role": "#10 RM", "name": "Emong"},
    {"role": "#11 CM", "name": "Magongo"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: 400),
            margin: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              children: [
                // Top bar with back button
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.red,
                        radius: 20,
                        child: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                // Logo
                Image.network(
                  'https://pplx-res.cloudinary.com/image/private/user_uploads/56434689/46c9daf9-b4e1-47d2-9553-0d464b262761/TeamBackground.jpg',
                  width: 90,
                  height: 90,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 8),
                // Team Name
                Text(
                  "Windhoek Wanderers",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                // Subtitle
                Text(
                  "4th in Mens Under 21 League",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 13,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 18),
                // Grid of players/coaches
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                      itemCount: members.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                           Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => PlayerScreen(
      name: members[index]["name"] ?? "Unknown",
      role: members[index]["role"] ?? "Player",
      number: members[index]["number"]?.toString() ?? "0",
    ),
  ),
);
                          },
                          child: _MemberCard(
                            role: members[index]["role"]!,
                            name: members[index]["name"]!,
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 70), // Space for FAB and nav bar
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        height: 64,
        width: 64,
        child: FloatingActionButton(
          backgroundColor: Colors.red,
          elevation: 6,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => PlayerRegistrationPage()),
            );
          },
          child: Icon(Icons.add, size: 36, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _CustomBottomNavBar(),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final String role;
  final String name;

  const _MemberCard({
    required this.role,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image, size: 30, color: Colors.grey[400]),
          SizedBox(height: 8),
          Text(
            role,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            name,
            style: TextStyle(fontSize: 11, color: Colors.grey[800]),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 8,
      child: Container(
        height: 60,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.home_outlined, color: Colors.grey[400], size: 30),
            Icon(Icons.groups, color: Colors.red, size: 30),
            SizedBox(width: 40), // Space for FAB
            Icon(Icons.calendar_today_outlined, color: Colors.grey[400], size: 28),
            Icon(Icons.person_outline, color: Colors.grey[400], size: 30),
          ],
        ),
      ),
    );
  }
}
