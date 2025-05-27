import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'PlayerScreen.dart';
import 'PlayerRegistration.dart';

class TeamPage extends StatefulWidget {
  final String teamName;
  final ImageProvider teamLogo;
  final String teamId;

  const TeamPage({super.key, 
    required this.teamName,
    required this.teamLogo,
    required this.teamId,
  });

  @override
  _TeamPageState createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  List<Map<String, dynamic>> members = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTeamMembers();
  }

  Future<void> fetchTeamMembers() async {
    print('Team ID: ${widget.teamId}');
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('teams')
          .doc(widget.teamId)
          .collection('members')
          .get();

      print('Fetched ${snapshot.docs.length} members.');

final data = snapshot.docs.map((doc) {
  final d = doc.data();
  d['id'] = doc.id;

  // Construct full name and map correct fields
  d['name'] = '${d['firstName']} ${d['lastName']}';
  d['role'] = 'Player'; // Set default or fetch from Firestore if available
  d['number'] = d['jerseyNumber'];
  d['position'] = d['position'] ?? 'Unknown';
  d['imageUrl'] = d['imageUrl'] ?? '';

  print('Mapped Member: name=${d['name']}, number=${d['number']}, position=${d['position']}, imageUrl=${d['imageUrl']}');

  return d;
}).toList();

      setState(() {
        members = data;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching team members: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

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
                Padding(
                  padding: const EdgeInsets.only(left: 12, top: 12, right: 12),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => Navigator.pop(context),
                        child: CircleAvatar(
                          backgroundColor: Colors.red,
                          radius: 20,
                          child: Icon(Icons.arrow_back, color: Colors.white),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                CircleAvatar(
                  backgroundImage: widget.teamLogo,
                  radius: 45,
                ),
                SizedBox(height: 8),
                Text(
                  widget.teamName,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                SizedBox(height: 4),
                Text(
                  "4th in Mens Under 21 League",
                  style: TextStyle(color: Colors.grey[600], fontSize: 13),
                ),
                SizedBox(height: 18),
                Expanded(
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : members.isEmpty
                          ? Center(child: Text("No players found."))
                          : Padding(
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
                                  final member = members[index];
                                  final name = member['name']?.toString() ?? 'Unnamed';
                                  final role = member['role']?.toString() ?? 'Player';
                                  final number = member['number']?.toString() ?? '0';
                                  final position = member['position']?.toString() ?? 'Unknown';

                                  return GestureDetector(
onTap: () {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PlayerScreen(
        docId: member['id'], // ✅ Pass document ID
        name: name,
        role: role,
        number: number,
        portraitBase64: member['portraitBase64'] ?? '',
        playerData: member, // ✅ Pass the entire player data map
      ),
    ),
  );
},
                                    child: _MemberCard(
                                      name: name,
                                      number: number,
                                      position: position,
                                     
                                    ),
                                  );
                                },
                              ),
                            ),
                ),
                SizedBox(height: 70),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlayerRegistrationPage(teamId: widget.teamId),
            ),
          );
          if (result == true) {
            fetchTeamMembers(); // Refresh the member list
          }
        },
        child: Icon(Icons.add, size: 36, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _CustomBottomNavBar(),
    );
  }
}

class _MemberCard extends StatelessWidget {
  final String name;
  final String number;
  final String position;

  const _MemberCard({
    required this.name,
    required this.number,
    required this.position,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.person, size: 28, color: Colors.grey[500]),
          SizedBox(height: 4),
          Flexible(
            child: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          SizedBox(height: 2),
          Text(
            'Jersey #$number',
            style: TextStyle(fontSize: 10, color: Colors.grey[700]),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          SizedBox(height: 2),
          Text(
            position,
            style: TextStyle(fontSize: 10, color: Colors.grey[600]),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
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
            SizedBox(width: 40), // space for FAB
            Icon(Icons.calendar_today_outlined, color: Colors.grey[400], size: 28),
            Icon(Icons.person_outline, color: Colors.grey[400], size: 30),
          ],
        ),
      ),
    );
  }
}
