import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'EditPlayer.dart';
import 'Transfer.dart';

class PlayerScreen extends StatelessWidget {
  final String docId;
  final String name;
  final String role;
  final String number;
  final String portraitBase64;
  final Map<String, dynamic> playerData;

  const PlayerScreen({
    super.key,
    required this.docId,
    required this.name,
    required this.role,
    required this.number,
    required this.portraitBase64,
    required this.playerData,
  });

  @override
  Widget build(BuildContext context) {
    Uint8List? imageBytes;
    try {
      imageBytes = base64Decode(portraitBase64);
    } catch (e) {
      print('Error decoding base64: $e');
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 270,
                    child: imageBytes != null
                        ? Image.memory(
                            imageBytes,
                            fit: BoxFit.cover,
                          )
                        : const Center(
                            child: Icon(Icons.broken_image,
                                size: 60, color: Colors.grey),
                          ),
                  ),
                  Positioned(
                    top: 16,
                    left: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                name,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Text(
                                    role,
                                    style: const TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "• #$number",
                                    style: TextStyle(
                                      color: Colors.grey[700],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "#$number",
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                            fontSize: 32,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Manage Player",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 12),
                    _buildActionButton("View Stats", context),
                    const SizedBox(height: 8),
                    _buildActionButton("Edit Details", context),
                    const SizedBox(height: 8),
                    _buildActionButton("Make Transfer", context),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildBottomNavBar(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(String text, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14),
          side: const BorderSide(color: Colors.red, width: 1.5),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        onPressed: () {
          if (text == "Edit Details") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditTeamMemberScreen(
                  docId: docId,
                  playerData: playerData,
                ),
              ),
            );
          }  else if (text == "Make Transfer") {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => TransferPlayerPage(
        playerId: docId,
        fromTeamId: playerData['teamId'], // <-- ensure this key exists in playerData
      ),
    ),
  );
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text('$text tapped')),
  );
}
        },
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const [
          Icon(Icons.home, color: Colors.grey),
          Icon(Icons.group, color: Colors.red),
          Icon(Icons.calendar_today, color: Colors.grey),
          Icon(Icons.more_horiz, color: Colors.grey),
        ],
      ),
    );
  }
}
