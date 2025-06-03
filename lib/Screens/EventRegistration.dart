import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:convert';

class EventCreationScreen extends StatefulWidget {
  const EventCreationScreen({super.key});

  @override
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _eventNameController = TextEditingController();
  final _descriptionController = TextEditingController();

  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  File? _pickedImage;

  List<String> _teams = [];
  String? _selectedTeamA;
  String? _selectedTeamB;

  Future<void> _loadTeams() async {
    final snapshot = await FirebaseFirestore.instance.collection('teams').get();
    setState(() {
      _teams = snapshot.docs.map((doc) => doc['name'].toString()).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTeams();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime(bool isStart) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _pickedImage = File(pickedFile.path);
      });
    }
  }

  void _clearForm() {
    _formKey.currentState?.reset();
    _eventNameController.clear();
    _descriptionController.clear();
    setState(() {
      _selectedDate = null;
      _startTime = null;
      _endTime = null;
      _pickedImage = null;
      _selectedTeamA = null;
      _selectedTeamB = null;
    });
  }

  void _createEvent() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedDate == null || _startTime == null || _endTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select date and time")),
        );
        return;
      }

      if (_selectedTeamA == null ||
          _selectedTeamB == null ||
          _selectedTeamA == _selectedTeamB) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please select two different teams")),
        );
        return;
      }

      try {
        String? base64Image;
        if (_pickedImage != null) {
          List<int> imageBytes = await _pickedImage!.readAsBytes();
          base64Image = base64Encode(imageBytes);
        }

        await FirebaseFirestore.instance.collection('events').add({
          'name': _eventNameController.text,
          'description': _descriptionController.text,
          'date': _selectedDate!.toIso8601String(),
          'startTime': _startTime!.format(context),
          'endTime': _endTime!.format(context),
          'timestamp': FieldValue.serverTimestamp(),
          'image': base64Image ?? "",
          'teamA': _selectedTeamA,
          'teamB': _selectedTeamB,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Event Created Successfully!")),
        );

        _clearForm();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to create event: $e")),
        );
      }
    }
  }

  @override
  void dispose() {
    _eventNameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 22,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                  SizedBox(height: 18),
                  TextFormField(
                    controller: _eventNameController,
                    validator: (value) => value == null || value.isEmpty ? "Event name is required" : null,
                    decoration: InputDecoration(
                      hintText: "Event Name",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: _pickDate,
                    child: AbsorbPointer(
                      child: TextFormField(
                        decoration: InputDecoration(
                          hintText: _selectedDate == null
                              ? "Date"
                              : "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}",
                          suffixIcon: Icon(Icons.calendar_today),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickTime(true),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: _startTime == null ? "Start Time" : _startTime!.format(context),
                              suffixIcon: Icon(Icons.access_time),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => _pickTime(false),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: _endTime == null ? "End Time" : _endTime!.format(context),
                              suffixIcon: Icon(Icons.access_time),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 16),
                  Text("Matchup", style: TextStyle(fontWeight: FontWeight.w600)),
                  SizedBox(height: 8),
                  Row(children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedTeamA,
                        hint: Text("Select Team A"),
                        items: _teams
                            .map((team) => DropdownMenuItem(value: team, child: Text(team)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTeamA = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedTeamB,
                        hint: Text("Select Team B"),
                        items: _teams
                            .map((team) => DropdownMenuItem(value: team, child: Text(team)))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedTeamB = value;
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ]),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 4,
                    validator: (value) => value == null || value.isEmpty ? "Description is required" : null,
                    decoration: InputDecoration(
                      hintText: "Type event description here",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  SizedBox(height: 18),
                  Text("Event Image", style: TextStyle(fontWeight: FontWeight.w500)),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      height: 90,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: _pickedImage == null
                          ? Center(child: Icon(Icons.add_photo_alternate, size: 36, color: Colors.grey))
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Image.file(_pickedImage!, fit: BoxFit.cover),
                            ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.red, width: 1.5),
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text("Cancel", style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _createEvent,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text("Create Event", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ]),
                  SizedBox(height: 16),
                  Text("Recent Events", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  SizedBox(
                    height: 150,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('events')
                          .orderBy('timestamp', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }
                        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                          return Center(child: Text("No events yet"));
                        }

                        final docs = snapshot.data!.docs;
                        return ListView.builder(
                          itemCount: docs.length,
                          itemBuilder: (context, index) {
                            final event = docs[index].data() as Map<String, dynamic>;
                            return ListTile(
                              contentPadding: EdgeInsets.zero,
                              leading: event['image'] != null && event['image'] != ""
                                  ? Image.memory(
                                      base64Decode(event['image']),
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    )
                                  : Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                              title: Text("${event['teamA'] ?? 'Team A'} vs ${event['teamB'] ?? 'Team B'}"),
                              subtitle: Text(event['description'] ?? ""),
                              trailing: Text(event['startTime'] ?? ""),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 6, offset: Offset(0, -2)),
      ]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ),
    );
  }
}
