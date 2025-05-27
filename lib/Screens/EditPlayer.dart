import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EditTeamMemberScreen extends StatefulWidget {
    final String docId;
  final Map<String, dynamic> playerData;

  const EditTeamMemberScreen({
    super.key,
    required this.docId,
    required this.playerData,
  });
  @override
  _EditTeamMemberScreenState createState() => _EditTeamMemberScreenState();
}

class _EditTeamMemberScreenState extends State<EditTeamMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _firstName;
  String? _lastName;
  String? _age;
  String? _position;
  String? _jerseyNumber;

  // Dummy image picker logic (replace with actual image picker)
  Widget _buildPlayerPortrait() {
    return GestureDetector(
      onTap: () {
        // TODO: Implement image picker logic
      },
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Icon(
            Icons.add_photo_alternate_outlined,
            color: Colors.grey[400],
            size: 40,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F8F8),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              width: 370,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 24,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      backgroundColor: Color(0xFFE53935),
                      radius: 24,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  // Title
                  Text(
                    'Player Portrait',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  // Portrait
                  _buildPlayerPortrait(),
                  SizedBox(height: 24),
                  // Form
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        // First Name
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'First Name',
                            filled: true,
                            fillColor: Color(0xFFF6F6F6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSaved: (value) => _firstName = value,
                        ),
                        SizedBox(height: 16),
                        // Last Name
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Last Name',
                            filled: true,
                            fillColor: Color(0xFFF6F6F6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onSaved: (value) => _lastName = value,
                        ),
                        SizedBox(height: 16),
                        // Age
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Age',
                            filled: true,
                            fillColor: Color(0xFFF6F6F6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _age = value,
                        ),
                        SizedBox(height: 16),
                        // Position Dropdown
                        DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            hintText: 'Position',
                            filled: true,
                            fillColor: Color(0xFFF6F6F6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          items: [
                            DropdownMenuItem(
                              value: 'Forward',
                              child: Text('Forward'),
                            ),
                            DropdownMenuItem(
                              value: 'Midfielder',
                              child: Text('Midfielder'),
                            ),
                            DropdownMenuItem(
                              value: 'Defender',
                              child: Text('Defender'),
                            ),
                            DropdownMenuItem(
                              value: 'Goalkeeper',
                              child: Text('Goalkeeper'),
                            ),
                          ],
                          onChanged: (value) {
                            setState(() {
                              _position = value;
                            });
                          },
                          value: _position,
                        ),
                        SizedBox(height: 16),
                        // Jersey Number
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Jersey Number',
                            filled: true,
                            fillColor: Color(0xFFF6F6F6),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _jerseyNumber = value,
                        ),
                        SizedBox(height: 32),
                        // Buttons Row
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Color(0xFFE53935),
                                    width: 2,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                ),
                                onPressed: () {
                                  // TODO: Implement delete logic
                                },
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                    color: Color(0xFFE53935),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFE53935),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                ),
onPressed: () async {
  if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();

    print("Saving player with docId: ${widget.docId}");

    try {
      await FirebaseFirestore.instance
          .collection('teams')
          .doc('RGvqtnIfLSKNbJflfHpN') // Use your actual team ID dynamically if needed
          .collection('members')
          .doc(widget.docId)
          .update({
        'firstName': _firstName ?? widget.playerData['firstName'],
        'lastName': _lastName ?? widget.playerData['lastName'],
        'age': int.tryParse(_age ?? '') ?? widget.playerData['age'],
        'position': _position ?? widget.playerData['position'],
        'jerseyNumber': int.tryParse(_jerseyNumber ?? '') ?? widget.playerData['jerseyNumber'],
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Player updated successfully')),
      );

      Navigator.of(context).pop();
    } catch (e) {
      print("Error updating player: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update player: $e')),
      );
    }
  }
},
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16),
                        // Bottom Navigation (dummy)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.home_outlined, color: Colors.grey[400], size: 32),
                            Icon(Icons.groups, color: Color(0xFFE53935), size: 32),
                            Icon(Icons.calendar_today_outlined, color: Colors.grey[400], size: 32),
                            Icon(Icons.chat_bubble_outline, color: Colors.grey[400], size: 32),
                          ],
                        ),
                        SizedBox(height: 8),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
