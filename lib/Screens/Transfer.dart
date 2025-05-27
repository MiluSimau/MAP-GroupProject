import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TransferPlayerPage extends StatefulWidget {
  final String playerId;
  final String fromTeamId;

  TransferPlayerPage({required this.playerId, required this.fromTeamId});

  @override
  State<TransferPlayerPage> createState() => _TransferPlayerPageState();
}

class _TransferPlayerPageState extends State<TransferPlayerPage> {
  List<Map<String, dynamic>> teamList = [];
  String? selectedTeamId;
  Map<String, dynamic>? fromTeam;
  Map<String, dynamic>? playerData;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    final firestore = FirebaseFirestore.instance;

    final fromTeamDoc = await firestore.collection('teams').doc(widget.fromTeamId).get();
    fromTeam = {
      'name': fromTeamDoc['name'],
      'logo': fromTeamDoc['logo'] ?? '',
    };

    final playerDoc = await firestore
        .collection('teams')
        .doc(widget.fromTeamId)
        .collection('players')
        .doc(widget.playerId)
        .get();

    playerData = playerDoc.data();

    final teamsSnapshot = await firestore.collection('teams').get();
    teamList = teamsSnapshot.docs
        .where((doc) => doc.id != widget.fromTeamId)
        .map((doc) => {
              'id': doc.id,
              'name': doc['name'],
              'logo': doc['logo'] ?? '',
            })
        .toList();

    setState(() {});
  }

  Future<void> handleTransfer() async {
    if (selectedTeamId == null || playerData == null) return;

    final firestore = FirebaseFirestore.instance;

    try {
      await firestore
          .collection('teams')
          .doc(selectedTeamId)
          .collection('players')
          .doc(widget.playerId)
          .set(playerData!);

      await firestore
          .collection('teams')
          .doc(widget.fromTeamId)
          .collection('players')
          .doc(widget.playerId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Player transferred successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Transfer failed")),
      );
    }
  }

  Widget buildTeamCard(Map<String, dynamic> team) {
    final isSelected = selectedTeamId == team['id'];
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTeamId = team['id'];
        });
      },
      child: Card(
        color: isSelected ? Colors.green[100] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: isSelected ? Colors.green : Colors.grey.shade300),
        ),
        child: ListTile(
          leading: team['logo'] != ''
              ? Image.network(team['logo'], width: 40, height: 40, errorBuilder: (_, __, ___) => Icon(Icons.shield))
              : Icon(Icons.shield_outlined),
          title: Text(team['name']),
          trailing: isSelected ? Icon(Icons.check_circle, color: Colors.green) : null,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Transfer Player"),
        backgroundColor: Colors.green[700],
      ),
      body: playerData == null || fromTeam == null
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Player Info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundImage: NetworkImage(
                          'https://pplx-res.cloudinary.com/image/private/user_uploads/56434689/21419eb8-9a65-4370-9e98-439812bcbb77/transfer.jpg',
                        ),
                      ),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            playerData!['name'] ?? 'Unknown Player',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            playerData!['position'] ?? '',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 32),

                  // From & To Team Info
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.network(fromTeam!['logo'], width: 50, height: 50, errorBuilder: (_, __, ___) => Icon(Icons.shield)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Icon(Icons.compare_arrows, color: Colors.red, size: 36),
                      ),
                      if (selectedTeamId != null)
                        Image.network(
                          teamList.firstWhere((t) => t['id'] == selectedTeamId)['logo'],
                          width: 50,
                          height: 50,
                          errorBuilder: (_, __, ___) => Icon(Icons.shield_outlined),
                        )
                      else
                        Icon(Icons.help_outline, size: 50),
                    ],
                  ),
                  SizedBox(height: 24),

                  // New Team Selection (ListView)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Tap a team to transfer to:", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    child: ListView.builder(
                      itemCount: teamList.length,
                      itemBuilder: (context, index) {
                        return buildTeamCard(teamList[index]);
                      },
                    ),
                  ),
                  SizedBox(height: 16),

                  // Transfer Button
                  ElevatedButton.icon(
                    onPressed: selectedTeamId == null ? null : handleTransfer,
                    icon: Icon(Icons.send),
                    label: Text("Confirm Transfer"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green[700],
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
