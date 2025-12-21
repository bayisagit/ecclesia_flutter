import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();
  final ImagePicker _picker = ImagePicker();

  String title = '';
  String description = '';
  String location = '';
  DateTime date = DateTime.now();
  File? _imageFile;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<String> _uploadImage() async {
    if (_imageFile == null) return '';
    try {
      final String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference ref = FirebaseStorage.instance.ref().child(
        'event_images/$fileName',
      );
      final UploadTask uploadTask = ref.putFile(_imageFile!);
      final TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      print('Error uploading image: $e');
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Event'),
        backgroundColor: Colors.blueAccent,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Event Title'),
                        validator: (val) =>
                            val!.isEmpty ? 'Please enter a title' : null,
                        onChanged: (val) => setState(() => title = val),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Description'),
                        validator: (val) =>
                            val!.isEmpty ? 'Please enter a description' : null,
                        onChanged: (val) => setState(() => description = val),
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        decoration: InputDecoration(labelText: 'Location'),
                        validator: (val) =>
                            val!.isEmpty ? 'Please enter a location' : null,
                        onChanged: (val) => setState(() => location = val),
                      ),
                      SizedBox(height: 20.0),
                      Row(
                        children: [
                          Text(
                            'Date: ${DateFormat('yyyy-MM-dd').format(date)}',
                          ),
                          SizedBox(width: 20.0),
                          ElevatedButton(
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: date,
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2101),
                              );
                              if (picked != null && picked != date)
                                setState(() {
                                  date = picked;
                                });
                            },
                            child: Text('Select Date'),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.0),
                      GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: _imageFile != null
                              ? Image.file(_imageFile!, fit: BoxFit.cover)
                              : Icon(
                                  Icons.add_a_photo,
                                  size: 50,
                                  color: Colors.grey,
                                ),
                        ),
                      ),
                      SizedBox(height: 20.0),
                      ElevatedButton(
                        child: Text('Create Event'),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);
                            String imageUrl = await _uploadImage();
                            await _db.addEvent(
                              title,
                              description,
                              date,
                              location,
                              user!.uid,
                              imageUrl,
                            );
                            setState(() => _isLoading = false);
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
