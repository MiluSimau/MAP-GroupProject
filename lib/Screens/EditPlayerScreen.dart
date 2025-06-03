// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_storage/firebase_storage.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';

// class EditPlayerScreen extends StatefulWidget {
//   final String teamId; // 👈 Add this
//   final String docId;
//   final String firstName;
//   final String lastName;
//   final int age;
//   final String position;
//   final int jerseyNumber;
//   final String imageUrl;

//   const EditPlayerScreen({
//     super.key,
//     required this.teamId, // 👈 Make sure this is required
//     required this.docId,
//     required this.firstName,
//     required this.lastName,
//     required this.age,
//     required this.position,
//     required this.jerseyNumber,
//     required this.imageUrl,
//   });

//   @override
//   _EditPlayerScreenState createState() => _EditPlayerScreenState();
// }

// class _EditPlayerScreenState extends State<EditPlayerScreen> {
//   late String _firstName;
//   late String _lastName;
//   late String _age;
//   late String _position;
//   late String _jerseyNumber;
//   String? _imageUrl;
//   File? _selectedImage;

//   @override
//   void initState() {
//     super.initState();
//     _firstName = widget.firstName;
//     _lastName = widget.lastName;
//     _age = widget.age.toString();
//     _position = widget.position;
//     _jerseyNumber = widget.jerseyNumber.toString();
//     _imageUrl = widget.imageUrl;
//   }

//   Future<void> _pickImage() async {
//     final pickedFile =
//         await ImagePicker().pickImage(source: ImageSource.gallery);
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }

//   Future<String?> _uploadImage(File imageFile) async {
//     try {
//       final fileName = DateTime.now().millisecondsSinceEpoch.toString();
//       final storageRef =
//           FirebaseStorage.instance.ref().child('player_images/$fileName');
//       await storageRef.putFile(imageFile);
//       return await storageRef.getDownloadURL();
//     } catch (e) {
//       print('Error uploading image: $e');
//       return null;
//     }
//   }

//   Future<void> _updatePlayer() async {
//     try {
//       // 1. Validate required fields
//       if (_firstName.isEmpty ||
//           _lastName.isEmpty ||
//           _age.isEmpty ||
//           _position.isEmpty ||
//           _jerseyNumber.isEmpty) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Please fill in all required fields.')),
//         );
//         return;
//       }

//       // 2. Validate and convert age and jersey number
//       int? parsedAge = int.tryParse(_age);
//       int? parsedJerseyNumber = int.tryParse(_jerseyNumber);

//       if (parsedAge == null || parsedJerseyNumber == null) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(
//               content: Text(
//                   'Please enter valid numbers for age and jersey number.')),
//         );
//         return;
//       }

//       // 3. Handle image upload if a new image is selected
//       String? imageUrl = _imageUrl;
//       if (_selectedImage != null) {
//         final uploadedUrl = await _uploadImage(_selectedImage!);
//         if (uploadedUrl != null) {
//           imageUrl = uploadedUrl;
//         } else {
//           throw Exception('Image upload failed.');
//         }
//       }

//       // 4. Update Firestore
// await FirebaseFirestore.instance
//     .collection('teams')
//     .doc(widget.teamId) // 👈 Access teamId via widget.teamId
//     .collection('members')
//     .doc(widget.docId)
//     .update({
//   'firstName': _firstName,
//   'lastName': _lastName,
//   'age': parsedAge,
//   'position': _position,
//   'jerseyNumber': parsedJerseyNumber,
//   'imageUrl': imageUrl,
// });

//       // 5. Notify success
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Player updated successfully!')),
//       );

//       // 6. Close the screen
//       Navigator.pop(context);
//     } catch (e) {
//       print('Error updating player: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Failed to update player: $e')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Edit Player'),
//       ),
//       body: SingleChildScrollView(
//         padding: EdgeInsets.all(16),
//         child: Column(
//           children: [
//             GestureDetector(
//               onTap: _pickImage,
//               child: CircleAvatar(
//                 radius: 60,
//                 backgroundImage: _selectedImage != null
//                     ? FileImage(_selectedImage!)
//                     : (_imageUrl != null && _imageUrl!.isNotEmpty)
//                         ? NetworkImage(_imageUrl!) as ImageProvider
//                         : AssetImage('assets/default_avatar.png'),
//               ),
//             ),
//             SizedBox(height: 16),
//             TextField(
//               decoration: InputDecoration(labelText: 'First Name'),
//               onChanged: (value) => _firstName = value,
//               controller: TextEditingController(text: _firstName),
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Last Name'),
//               onChanged: (value) => _lastName = value,
//               controller: TextEditingController(text: _lastName),
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Age'),
//               keyboardType: TextInputType.number,
//               onChanged: (value) => _age = value,
//               controller: TextEditingController(text: _age),
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Position'),
//               onChanged: (value) => _position = value,
//               controller: TextEditingController(text: _position),
//             ),
//             TextField(
//               decoration: InputDecoration(labelText: 'Jersey Number'),
//               keyboardType: TextInputType.number,
//               onChanged: (value) => _jerseyNumber = value,
//               controller: TextEditingController(text: _jerseyNumber),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: _updatePlayer,
//               child: Text('Update Player'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
