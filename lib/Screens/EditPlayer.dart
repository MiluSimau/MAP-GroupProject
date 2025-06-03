import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class EditTeamMemberScreen extends StatefulWidget {
  final String docId;
  final String teamId;
  final Map<String, dynamic> playerData;

  const EditTeamMemberScreen({
    super.key,
    required this.docId,
    required this.teamId,
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
  String? _base64Image;
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Widget _buildPlayerPortrait() {
    Widget imageWidget;
    if (_base64Image != null) {
      imageWidget = Image.memory(
        base64Decode(_base64Image!),
        fit: BoxFit.cover,
      );
    } else if (widget.playerData['portraitBase64'] != null) {
      try {
        imageWidget = Image.memory(
          base64Decode(widget.playerData['portraitBase64']),
          fit: BoxFit.cover,
        );
      } catch (e) {
        imageWidget = Icon(
          Icons.add_photo_alternate_outlined,
          color: Colors.grey[400],
          size: 40,
        );
      }
    } else {
      imageWidget = Icon(
        Icons.add_photo_alternate_outlined,
        color: Colors.grey[400],
        size: 40,
      );
    }

    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: imageWidget,
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
                  Text(
                    'Player Portrait',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildPlayerPortrait(),
                  SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: widget.playerData['firstName'],
                          decoration: _inputDecoration('First Name'),
                          onSaved: (value) => _firstName = value,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          initialValue: widget.playerData['lastName'],
                          decoration: _inputDecoration('Last Name'),
                          onSaved: (value) => _lastName = value,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          initialValue:
                              widget.playerData['age']?.toString() ?? '',
                          decoration: _inputDecoration('Age'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _age = value,
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: _inputDecoration('Position'),
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
                          value: _position ?? widget.playerData['position'],
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          initialValue:
                              widget.playerData['jerseyNumber']?.toString() ??
                                  '',
                          decoration: _inputDecoration('Jersey Number'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _jerseyNumber = value,
                        ),
                        SizedBox(height: 32),
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

                                    final memberDocRef = FirebaseFirestore
                                        .instance
                                        .collection('teams')
                                        .doc(widget.teamId)
                                        .collection('members')
                                        .doc(widget.docId);

                                    try {
                                      final docSnapshot =
                                          await memberDocRef.get();
                                      if (docSnapshot.exists) {
                                        await memberDocRef.update({
                                          'firstName': _firstName ??
                                              widget.playerData['firstName'],
                                          'lastName': _lastName ??
                                              widget.playerData['lastName'],
                                          'age': int.tryParse(_age ?? '') ??
                                              widget.playerData['age'],
                                          'position': _position ??
                                              widget.playerData['position'],
                                          'jerseyNumber':
                                              int.tryParse(_jerseyNumber ?? '') ??
                                                  widget
                                                      .playerData['jerseyNumber'],
                                          'portraitBase64': _base64Image ??
                                              widget.playerData['portraitBase64'],
                                        });

                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Player updated successfully'),
                                          ),
                                        );

                                        // Refresh the screen
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                EditTeamMemberScreen(
                                              docId: widget.docId,
                                              teamId: widget.teamId,
                                              playerData: {
                                                ...widget.playerData,
                                                'firstName': _firstName ??
                                                    widget
                                                        .playerData['firstName'],
                                                'lastName': _lastName ??
                                                    widget
                                                        .playerData['lastName'],
                                                'age': int.tryParse(_age ?? '') ??
                                                    widget.playerData['age'],
                                                'position': _position ??
                                                    widget
                                                        .playerData['position'],
                                                'jerseyNumber':
                                                    int.tryParse(
                                                            _jerseyNumber ?? '') ??
                                                        widget.playerData[
                                                            'jerseyNumber'],
                                                'portraitBase64': _base64Image ??
                                                    widget.playerData[
                                                        'portraitBase64'],
                                              },
                                            ),
                                          ),
                                        );
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Player not found. Cannot update.'),
                                          ),
                                        );
                                      }
                                    } catch (e) {
                                      print("Error updating player: $e");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                'Failed to update player: $e')),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Icon(Icons.home_outlined,
                                color: Colors.grey[400], size: 32),
                            Icon(Icons.groups,
                                color: Color(0xFFE53935), size: 32),
                            Icon(Icons.calendar_today_outlined,
                                color: Colors.grey[400], size: 32),
                            Icon(Icons.chat_bubble_outline,
                                color: Colors.grey[400], size: 32),
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

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Color(0xFFF6F6F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
