import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class EditTeamMemberScreen extends StatefulWidget {
  final String docId;
  final Map<String, dynamic> playerData;

    const EditTeamMemberScreen({
    Key? key,
    required this.docId,
    required this.playerData,
  }) : super(key: key);


  @override
  _EditTeamMemberScreenState createState() => _EditTeamMemberScreenState();
}

class _EditTeamMemberScreenState extends State<EditTeamMemberScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _firstName;
  late String _lastName;
  late String _age;
  late String _position;
  late String _jerseyNumber;
  String? _imageUrl;
  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _firstName = widget.playerData['firstName'] ?? '';
    _lastName = widget.playerData['lastName'] ?? '';
    _age = widget.playerData['age'] ?? '';
    _position = widget.playerData['position'] ?? '';
    _jerseyNumber = widget.playerData['jerseyNumber'] ?? '';
    _imageUrl = widget.playerData['imageUrl'];
  }

  Future<void> _pickImage() async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _selectedImage = File(pickedImage.path);
      });
    }
  }

  Future<String?> _uploadImage(File image) async {
    try {
      String fileName = path.basename(image.path);
      final ref = FirebaseStorage.instance
          .ref()
          .child('player_images')
          .child('${widget.docId}_$fileName');

      await ref.putFile(image);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Image upload error: $e');
      return null;
    }
  }

  Future<void> _updatePlayer() async {
    try {
      String? imageUrl = _imageUrl;

      if (_selectedImage != null) {
        imageUrl = await _uploadImage(_selectedImage!);
      }

      await FirebaseFirestore.instance
          .collection('players')
          .doc(widget.docId)
          .update({
        'firstName': _firstName,
        'lastName': _lastName,
        'age': _age,
        'position': _position,
        'jerseyNumber': _jerseyNumber,
        'imageUrl': imageUrl,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Player updated successfully')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error updating player: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update player')),
      );
    }
  }

  Future<void> _deletePlayer() async {
    try {
      await FirebaseFirestore.instance
          .collection('players')
          .doc(widget.docId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Player deleted')),
      );
      Navigator.pop(context);
    } catch (e) {
      print('Error deleting player: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete player')),
      );
    }
  }

  Widget _buildPlayerPortrait() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(10),
        ),
        child: _selectedImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(_selectedImage!, fit: BoxFit.cover),
              )
            : _imageUrl != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(_imageUrl!, fit: BoxFit.cover),
                  )
                : Center(
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
              padding: EdgeInsets.all(24),
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
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Player Portrait',
                    style:
                        TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                  SizedBox(height: 12),
                  _buildPlayerPortrait(),
                  SizedBox(height: 24),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          initialValue: _firstName,
                          decoration: _inputDecoration('First Name'),
                          onSaved: (value) => _firstName = value!,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          initialValue: _lastName,
                          decoration: _inputDecoration('Last Name'),
                          onSaved: (value) => _lastName = value!,
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          initialValue: _age,
                          decoration: _inputDecoration('Age'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _age = value!,
                        ),
                        SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          decoration: _inputDecoration('Position'),
                          value: _position.isNotEmpty ? _position : null,
                          items: ['Forward', 'Midfielder', 'Defender', 'Goalkeeper']
                              .map((pos) => DropdownMenuItem(
                                    value: pos,
                                    child: Text(pos),
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _position = value!),
                        ),
                        SizedBox(height: 16),
                        TextFormField(
                          initialValue: _jerseyNumber,
                          decoration: _inputDecoration('Jersey Number'),
                          keyboardType: TextInputType.number,
                          onSaved: (value) => _jerseyNumber = value!,
                        ),
                        SizedBox(height: 32),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                      color: Color(0xFFE53935), width: 2),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                ),
                                onPressed: _deletePlayer,
                                child: Text(
                                  'Delete',
                                  style: TextStyle(
                                      color: Color(0xFFE53935),
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFE53935),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  padding: EdgeInsets.symmetric(vertical: 18),
                                ),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    _formKey.currentState!.save();
                                    _updatePlayer();
                                  }
                                },
                                child: Text(
                                  'Save',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16),
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

  InputDecoration _inputDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: Color(0xFFF6F6F6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
