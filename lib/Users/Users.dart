import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../Screens/EventScreen.dart';
import '../Screens/Announcement.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final User? user = FirebaseAuth.instance.currentUser;

  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  late PageController _pageController;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _slideAnimation = Tween<Offset>(begin: const Offset(0, 0.1), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _controller.forward();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<Map<String, dynamic>?> getTeamData(String teamName) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('teams')
          .where('name', isEqualTo: teamName)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
    } catch (e) {
      print('Error fetching team data: $e');
    }
    return null;
  }

  void _onItemTapped(int index) {
    _pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    if (index == 0) {
      _controller.reset();
      _controller.forward();
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
              Expanded(child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600))),
            ],
          ),
          const SizedBox(height: 4),
          Text(count, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _showMatchDetailsBottomSheet(BuildContext context, Map<String, dynamic> data, ImageProvider teamAImage, ImageProvider teamBImage) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 24,
            left: 24,
            right: 24,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Match Details",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Text("Start Time: ${data['startTime'] ?? 'TBD'}", style: const TextStyle(fontSize: 16)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildTeamDetailsColumn(data['teamA'] ?? 'Team A', teamAImage, data['scoreTeamA'] ?? 0),
                    const Text("VS", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                    _buildTeamDetailsColumn(data['teamB'] ?? 'Team B', teamBImage, data['scoreTeamB'] ?? 0),
                  ],
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close"),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTeamDetailsColumn(String name, ImageProvider imageProvider, int score) {
    return Column(
      children: [
        CircleAvatar(
          backgroundImage: imageProvider,
          radius: 50,
        ),
        const SizedBox(height: 8),
        Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text("Score: $score", style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildMainHomeContent() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: ListView(
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
            SizedBox(
              height: 260,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('events').orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text("No matches found."));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final doc = snapshot.data!.docs[index];
                      final data = doc.data();

                      final teamA = data['teamA'] ?? 'Team A';
                      final teamB = data['teamB'] ?? 'Team B';

                      return FutureBuilder(
                        future: Future.wait([
                          getTeamData(teamA),
                          getTeamData(teamB),
                        ]),
                        builder: (context, AsyncSnapshot<List<Map<String, dynamic>?>> teamSnapshots) {
                          if (!teamSnapshots.hasData) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          final teamAData = teamSnapshots.data![0];
                          final teamBData = teamSnapshots.data![1];

                          ImageProvider teamAImageProvider = const AssetImage('assets/logo.png');
                          ImageProvider teamBImageProvider = const AssetImage('assets/logo.png');

                          try {
                            if (teamAData?['logoBase64'] != null && teamAData!['logoBase64'].isNotEmpty) {
                              final bytes = base64Decode(teamAData['logoBase64']);
                              teamAImageProvider = MemoryImage(bytes);
                            }
                          } catch (_) {}

                          try {
                            if (teamBData?['logoBase64'] != null && teamBData!['logoBase64'].isNotEmpty) {
                              final bytes = base64Decode(teamBData['logoBase64']);
                              teamBImageProvider = MemoryImage(bytes);
                            }
                          } catch (_) {}

                          Widget buildTeamColumn(String name, ImageProvider imageProvider) {
                            return Column(
                              children: [
                                CircleAvatar(
                                  backgroundImage: imageProvider,
                                  radius: 40,
                                ),
                                const SizedBox(height: 4),
                                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  (data['scoreTeamA'] != null && name == teamA)
                                      ? data['scoreTeamA'].toString()
                                      : (data['scoreTeamB'] != null && name == teamB)
                                          ? data['scoreTeamB'].toString()
                                          : "0",
                                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                              ],
                            );
                          }

                          return Container(
                            width: 300,
                            margin: const EdgeInsets.only(right: 12),
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  children: [
                                    Text(data['startTime'] ?? 'TBD', style: const TextStyle(fontWeight: FontWeight.bold)),
                                    const SizedBox(height: 12),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                      children: [
                                        buildTeamColumn(teamA, teamAImageProvider),
                                        const Text("VS", style: TextStyle(fontWeight: FontWeight.bold)),
                                        buildTeamColumn(teamB, teamBImageProvider),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    ElevatedButton(
                                      onPressed: () {
                                        _showMatchDetailsBottomSheet(context, data, teamAImageProvider, teamBImageProvider);
                                      },
                                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                      child: const Text("View Details"),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmLogout(BuildContext context) async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout Confirmation"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text("Cancel")),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset('assets/nhu_logo_red.png', height: 60),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none, color: Colors.black87), onPressed: () {}),
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
                backgroundColor: Colors.transparent,
                child: user?.photoURL == null ? const Icon(Icons.account_circle, color: Colors.grey) : null,
              ),
            ),
          ),
        ],
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() => _selectedIndex = index);
          if (index == 0) {
            _controller.reset();
            _controller.forward();
          }
        },
        children: [
          _buildMainHomeContent(),
          
          EventsScreen(),
          AnnouncementScreen(),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(icon: Icon(Icons.home, color: _selectedIndex == 0 ? Colors.red : Colors.grey), onPressed: () => _onItemTapped(0)),
            IconButton(icon: Icon(Icons.groups, color: _selectedIndex == 1 ? Colors.red : Colors.grey), onPressed: () => _onItemTapped(1)),
            const SizedBox(width: 1),
            IconButton(icon: Icon(Icons.calendar_today, color: _selectedIndex == 2 ? Colors.red : Colors.grey), onPressed: () => _onItemTapped(2)),
            IconButton(icon: Icon(Icons.chat_bubble_outline, color: _selectedIndex == 3 ? Colors.red : Colors.grey), onPressed: () => _onItemTapped(3)),
          ],
        ),
      ),
    );
  }
}
