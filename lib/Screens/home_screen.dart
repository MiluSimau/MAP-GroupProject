import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'teamsPage.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  int _selectedIndex = 0;

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout Confirmation"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (shouldLogout == true) {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  Widget _buildAnalyticsCard(String label, String count, Color color, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 5)],
      ),
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            count,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildMainHomeContent() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text("System-wide Analytics", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 20),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          crossAxisSpacing: 25,
          mainAxisSpacing: 15,
          childAspectRatio: 2,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildAnalyticsCard("Total Registered Teams", "150", Colors.green, Icons.groups),
            _buildAnalyticsCard("Total Registered Players", "1000", Colors.red, Icons.person),
            _buildAnalyticsCard("Upcoming Events", "6", Colors.blue, Icons.event),
            _buildAnalyticsCard("Registered Officials", "12", Colors.orange, Icons.verified_user),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Matches and Scores", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TextButton(onPressed: () {}, child: const Text("See All")),
          ],
        ),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text("FRI 9 MAY @ 10:00 AM", style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(children: [
                      Image.asset("assets/old_boys.png", height: 100),
                      const SizedBox(height: 4),
                      const Text("Old Boys"),
                      const Text("3", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                    ]),
                    const Text("VS", style: TextStyle(fontWeight: FontWeight.bold)),
                    Column(children: [
                      Image.asset("assets/Hokey_club.png", height: 100),
                      const SizedBox(height: 4),
                      const Text("Rockers Club"),
                      const Text("1", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16))
                    ]),
                  ],
                ),
                const SizedBox(height: 12),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text("Final"),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Recent Activity", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            TextButton(onPressed: () {}, child: const Text("See All")),
          ],
        ),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: const ListTile(
            leading: Icon(Icons.update, color: Colors.blueAccent),
            title: Text("Player Updated"),
            tileColor: Colors.white,
          ),
        ),
        Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          child: ListTile(
            leading: const Icon(Icons.add_circle, color: Colors.green),
            title: const Text("New Team Registered"),
            tileColor: Colors.white,
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.green, borderRadius: BorderRadius.circular(15)),
              child: const Text("NEW", style: TextStyle(color: Colors.white, fontSize: 14)),
            ),
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> get _pages => [
        _buildMainHomeContent(),
        TeamsPage(),
        const Center(child: Text("Calendar Placeholder")),
        const Center(child: Text("Profile Placeholder")),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset('assets/nhu_logo_red.png', height: 60),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black87),
            onPressed: () {},
          ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') _confirmLogout(context);
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'logout', child: Text('Logout')),
            ],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: CircleAvatar(
                backgroundImage: user?.photoURL != null ? NetworkImage(user!.photoURL!) : null,
                child: user?.photoURL == null
                    ? const Icon(Icons.account_circle, color: Colors.grey)
                    : null,
                backgroundColor: Colors.transparent,
              ),
            ),
          ),
        ],
      ),
      body: _pages[_selectedIndex],
bottomNavigationBar: BottomAppBar(
  shape: const CircularNotchedRectangle(),
  notchMargin: 8,
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      IconButton(
        icon: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.red : Colors.grey),
        onPressed: () => _onItemTapped(0),
      ),
      IconButton(
        icon: Icon(Icons.groups, color: _selectedIndex == 1 ? Colors.red : Colors.grey),
        onPressed: () => _onItemTapped(1),
      ),
      const SizedBox(width: 1), // space for FAB
      IconButton(
        icon: Icon(Icons.calendar_today, color: _selectedIndex == 2 ? Colors.red : Colors.grey),
        onPressed: () => _onItemTapped(2),
      ),
      IconButton(
        icon: Icon(Icons.person, color: _selectedIndex == 3 ? Colors.red : Colors.grey),
        onPressed: () => _onItemTapped(3),
      ),
    ],
  ),
),
    );
  }
}
