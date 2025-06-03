import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as path;
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:convert';
import 'dart:typed_data';

class TeamRegistrationPage extends StatefulWidget {
  const TeamRegistrationPage({super.key});

  @override
  _TeamRegistrationPageState createState() => _TeamRegistrationPageState();
}

class _TeamRegistrationPageState extends State<TeamRegistrationPage> {
  String? selectedGender;
  String? selectedRegion;
  String? selectedYear;
  String? selectedLeague;

  final TextEditingController _teamNameController = TextEditingController();

  final List<String> regions = ['Region 1', 'Region 2', 'Region 3'];
  final List<String> years = ['2022', '2023', '2024'];
  final List<String> leagues = ['Division 1', 'Division 2', 'Division 3'];

  bool isLoading = false;

  File? _logoImageFile;
  String? _logoBase64;
  final ImagePicker _picker = ImagePicker();

  Future<void> _registerTeam() async {
    final teamName = _teamNameController.text.trim();

    if (teamName.isEmpty || _logoBase64 == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Team name and logo are required."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      // Check for duplicate team name
      final duplicateQuery = await FirebaseFirestore.instance
          .collection('teams')
          .where('name', isEqualTo: teamName)
          .get();

      if (duplicateQuery.docs.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("A team with this name already exists. Please choose another name."),
            backgroundColor: Colors.orange,
          ),
        );
        setState(() => isLoading = false);
        return;
      }

      // If no duplicates, proceed to register the team
      await FirebaseFirestore.instance.collection('teams').add({
        'name': teamName,
        'logoBase64': _logoBase64!,
        'gender': selectedGender ?? 'Unspecified',
        'region': selectedRegion ?? 'Unknown',
        'yearFounded': selectedYear ?? 'Unknown',
        'league': selectedLeague ?? 'Unknown',
        'createdAt': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Team registered successfully!'),
        backgroundColor: Colors.green,
      ));

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to register team: $e'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _pickLogoImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final tempFile = File(pickedFile.path);
      final bytes = await tempFile.readAsBytes();
      final base64String = base64Encode(bytes);

      final appDir = await getApplicationDocumentsDirectory();
      final fileName = 'team_logo_${DateTime.now().millisecondsSinceEpoch}.png';
      final savedImage = await tempFile.copy(path.join(appDir.path, fileName));

      setState(() {
        _logoImageFile = savedImage;
        _logoBase64 = base64String;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Uint8List? logoBytes = _logoBase64 != null ? base64Decode(_logoBase64!) : null;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 350,
            margin: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.red, size: 28),
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints(),
                      ),
                    ),
                    SizedBox(height: 8),
                    Center(
                      child: Column(
                        children: [
                          Text("Logo", style: TextStyle(fontSize: 14)),
                          SizedBox(height: 6),
                          GestureDetector(
                            onTap: _pickLogoImage,
                            child: Container(
                              width: 70,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Colors.grey[200],
                                borderRadius: BorderRadius.circular(8),
                                image: logoBytes != null
                                    ? DecorationImage(
                                        image: MemoryImage(logoBytes),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                              child: logoBytes == null
                                  ? Icon(Icons.add_photo_alternate,
                                      size: 32, color: Colors.grey[400])
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 18),
                    Text("Gender", style: TextStyle(fontSize: 14), textAlign: TextAlign.center),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _genderButton('Men', Icons.man, selectedGender == 'Men', () {
                          setState(() => selectedGender = 'Men');
                        }),
                        SizedBox(width: 16),
                        _genderButton('Women', Icons.woman, selectedGender == 'Women', () {
                          setState(() => selectedGender = 'Women');
                        }),
                      ],
                    ),
                    SizedBox(height: 18),
                    _buildTextField("Team Name"),
                    SizedBox(height: 12),
                    _buildDropdown("Region", regions, selectedRegion, (value) {
                      setState(() => selectedRegion = value);
                    }),
                    SizedBox(height: 12),
                    _buildDropdown("Year Founded", years, selectedYear, (value) {
                      setState(() => selectedYear = value);
                    }),
                    SizedBox(height: 12),
                    _buildDropdown("League/ Division", leagues, selectedLeague, (value) {
                      setState(() => selectedLeague = value);
                    }),
                    SizedBox(height: 28),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: BorderSide(color: Colors.red),
                              padding: EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: () => Navigator.pop(context),
                            child: Text('Cancel', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.red,
                              padding: EdgeInsets.symmetric(vertical: 14),
                            ),
                            onPressed: isLoading ? null : _registerTeam,
                            child: isLoading
                                ? CircularProgressIndicator(color: Colors.white)
                                : Text('Register', style: TextStyle(fontSize: 16)),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(Icons.home_outlined, color: Colors.grey[400], size: 28),
                        Icon(Icons.groups, color: Colors.red, size: 28),
                        Icon(Icons.calendar_today_outlined, color: Colors.grey[400], size: 28),
                        Icon(Icons.person_outline, color: Colors.grey[400], size: 28),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _genderButton(String label, IconData icon, bool selected, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? const Color.fromARGB(255, 66, 8, 4) : Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: [
              Icon(icon, color: selected ? Colors.white : Colors.grey[600], size: 28),
              SizedBox(height: 4),
              Text(label, style: TextStyle(color: selected ? Colors.white : Colors.grey[700], fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint) {
    return TextField(
      controller: _teamNameController,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, String? value, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      value: value,
      items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
      onChanged: onChanged,
      icon: Icon(Icons.keyboard_arrow_down),
    );
  }
}
