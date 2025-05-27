import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class PlayerRegistrationPage extends StatefulWidget {
  final String teamId;

  const PlayerRegistrationPage({required this.teamId, super.key});

  @override
  _PlayerRegistrationPageState createState() => _PlayerRegistrationPageState();
}

class _PlayerRegistrationPageState extends State<PlayerRegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  final _picker = ImagePicker();

  File? _selectedImage;
  bool _isUploading = false;
  String? _selectedPosition;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _jerseyNumberController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _ageController.dispose();
    _jerseyNumberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _registerPlayer() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isUploading = true);

    try {
      String? imageBase64;
      if (_selectedImage != null) {
        final bytes = await _selectedImage!.readAsBytes();
        imageBase64 = base64Encode(bytes);
      }

await FirebaseFirestore.instance
    .collection('teams')
    .doc(widget.teamId)
    .collection('members')
    .add({
  'firstName': _firstNameController.text.trim(),
  'lastName': _lastNameController.text.trim(),
  'age': int.parse(_ageController.text.trim()),
  'jerseyNumber': int.parse(_jerseyNumberController.text.trim()),
  'position': _selectedPosition,
  'portraitBase64': imageBase64,
  'registeredAt': FieldValue.serverTimestamp(),
});

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Player registered successfully!')),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.red, size: 28),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Player Portrait',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: _pickImage,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        image: _selectedImage != null
                            ? DecorationImage(
                                image: FileImage(_selectedImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: _selectedImage == null
                          ? Icon(Icons.camera_alt, size: 40, color: Colors.grey[500])
                          : null,
                    ),
                  ),
                  const SizedBox(height: 24),

                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        _buildTextField('First Name', controller: _firstNameController),
                        const SizedBox(height: 16),
                        _buildTextField('Last Name', controller: _lastNameController),
                        const SizedBox(height: 16),
                        _buildTextField(
                          'Age',
                          controller: _ageController,
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val == null || val.isEmpty || int.tryParse(val) == null
                                  ? 'Enter valid age'
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        _buildDropdownField(),
                        const SizedBox(height: 16),
                        _buildTextField(
                          'Jersey Number',
                          controller: _jerseyNumberController,
                          keyboardType: TextInputType.number,
                          validator: (val) =>
                              val == null || val.isEmpty || int.tryParse(val) == null
                                  ? 'Enter valid jersey number'
                                  : null,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.red),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                          onPressed: _isUploading ? null : _registerPlayer,
                          child: _isUploading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text(
                                  'Register',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    String hint, {
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator ??
          (value) => value == null || value.trim().isEmpty ? 'Please enter $hint' : null,
    );
  }

  Widget _buildDropdownField() {
    return DropdownButtonFormField<String>(
      value: _selectedPosition,
      decoration: InputDecoration(
        hintText: 'Position',
        filled: true,
        fillColor: Colors.grey[100],
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      items: ['Forward', 'Midfielder', 'Defender', 'Goalkeeper', 'Coach']
          .map((pos) => DropdownMenuItem(value: pos, child: Text(pos)))
          .toList(),
      onChanged: (val) => setState(() => _selectedPosition = val),
      validator: (val) => val == null ? 'Please select a position' : null,
    );
  }
}
 