import 'package:flutter/material.dart';

class TeamRegistrationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(180),
          child: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF8B39F6), Color(0xFFB16CEA)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    SizedBox(height: 16),
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Text(
                        "NHU",
                        style: TextStyle(
                          color: Color(0xFF8B39F6),
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      "Namibia Hockey Union",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                      "Connecting the hockey community",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            bottom: TabBar(
              indicatorColor: Colors.white,
              labelColor: Colors.white,
              unselectedLabelColor: Colors.white70,
              tabs: [
                Tab(text: "Home"),
                Tab(text: "Events"),
                Tab(text: "Teams"),
                Tab(text: "Register"),
              ],
            ),
          ),
        ),
        body: TabBarView(
          children: [
            HomeContent(),
            EventsTab(), // <-- MODIFIED: Events tab content
            Center(child: Text("Teams")),
            Center(child: Text("Register")),
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 200, left: 12, right: 12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Upcoming Events",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF4B2067),
                ),
              ),
              SizedBox(height: 16),
              EventItem(
                date: "15\nJUN",
                title: "National Championship",
                location: "Windhoek Hockey Stadium",
                time: "9:00 AM - 5:00 PM",
              ),
              Divider(),
              EventItem(
                date: "22\nJUN",
                title: "Junior Tournament",
                location: "Coastal Hockey Club",
                time: "10:00 AM - 4:00 PM",
              ),
              SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF8B39F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  onPressed: () {},
                  child: Text("View All Events"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventItem extends StatelessWidget {
  final String date, title, location, time;

  EventItem({
    required this.date,
    required this.title,
    required this.location,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFF8B39F6),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            date,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF4B2067),
                ),
              ),
              Text(
                location,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ----------------- NEW EVENTS TAB WIDGETS BELOW -----------------

class EventsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(top: 24, left: 12, right: 12),
      child: Card(
        color: Color(0xFFF8F6FC),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "June 2023 Events",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF4B2067),
                ),
              ),
              SizedBox(height: 16),
              EventCard(
                date: "15\nJUN",
                title: "National Championship",
                location: "Windhoek Hockey Stadium",
                time: "9:00 AM - 5:00 PM",
              ),
              Divider(height: 32, color: Color(0xFFE5D8F9)),
              EventCard(
                date: "22\nJUN",
                title: "Junior Tournament",
                location: "Coastal Hockey Club",
                time: "10:00 AM - 4:00 PM",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventCard extends StatelessWidget {
  final String date, title, location, time;

  EventCard({
    required this.date,
    required this.title,
    required this.location,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Date Box
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: Color(0xFF8B39F6),
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          child: Text(
            date,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 15,
            ),
          ),
        ),
        SizedBox(width: 16),
        // Event Details
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF4B2067),
                ),
              ),
              SizedBox(height: 2),
              Text(
                location,
                style: TextStyle(
                  color: Colors.grey[700],
                  fontSize: 13,
                ),
              ),
              Text(
                time,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF8B39F6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  elevation: 0,
                ),
                onPressed: () {
                  // Add registration logic here
                },
                child: Text("Register"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ----------------- BOTTOM NAVIGATION BAR -----------------

class CustomBottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Color(0xFF8B39F6),
      unselectedItemColor: Colors.grey,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: "Events",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: "Teams",
        ),
        BottomNavigationBarItem(
          icon: Stack(
            children: [
              Icon(Icons.notifications),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.amber,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  constraints: BoxConstraints(
                    minWidth: 16,
                    minHeight: 16,
                  ),
                  child: Text(
                    '3',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          label: "Notifications",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
      type: BottomNavigationBarType.fixed,
    );
  }
}
