import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../../models/ministry_post_model.dart';
import '../../services/database_service.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _audioUrlController = TextEditingController();
  final _heardCountController = TextEditingController();
  final _hopeCountController = TextEditingController();
  final _believedCountController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String _selectedMinistry = 'Worship Team';
  String _selectedType = 'general';
  bool _isLoading = false;

  final List<String> _ministries = [
    'Worship Team',
    'Prayer Team',
    'Outreach Team',
    'Bible Study Team',
    'Welcome Team',
    'Media Team',
    'Ebenezer Team',
  ];

  final List<String> _types = ['general', 'mission', 'event'];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _audioUrlController.dispose();
    _heardCountController.dispose();
    _hopeCountController.dispose();
    _believedCountController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitPost() async {
    final user = Provider.of<User?>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        String imageUrl = '';
        if (_imageFile != null) {
          imageUrl =
              await DatabaseService().uploadImage(
                _imageFile!,
                'ministry_posts',
              ) ??
              '';
        }

        final post = MinistryPostModel(
          id: '', // Firestore will generate ID
          ministryName: _selectedMinistry,
          title: _titleController.text,
          content: _contentController.text,
          imageUrl: imageUrl,
          audioUrl: _audioUrlController.text,
          date: DateTime.now(),
          type: _selectedType,
          heardCount: int.tryParse(_heardCountController.text),
          hopeCount: int.tryParse(_hopeCountController.text),
          believedCount: int.tryParse(_believedCountController.text),
        );

        // If type is event, also add to main events collection
        if (_selectedType == 'event') {
          await DatabaseService().addMinistryPost(post);
          await DatabaseService().addEvent(
            _titleController.text,
            _contentController.text,
            DateTime.now(), // Or add a date picker if needed
            _selectedMinistry, // Use ministry name as location/context
            user?.uid ?? 'admin',
            imageUrl,
          );
        } else {
          await DatabaseService().addMinistryPost(post);
        }

        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Post added successfully')));
        Navigator.pop(context);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding post: $e')));
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Ministry Post')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: InputDecoration(labelText: 'Post Type'),
                items: _types.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value.toUpperCase().replaceAll('_', ' ')),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedType = newValue!;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                initialValue: _selectedMinistry,
                decoration: InputDecoration(labelText: 'Ministry'),
                items: _ministries.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedMinistry = newValue!;
                    // Auto-select type based on ministry for convenience
                    if (_selectedMinistry == 'Outreach Team') {
                      _selectedType = 'mission';
                    } else {
                      _selectedType = 'general';
                    }
                  });
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(labelText: 'Title'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(labelText: 'Content'),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.blueAccent
                          : Colors.black12,
                    ),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _imageFile!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_a_photo,
                              size: 50,
                              color: Theme.of(context).iconTheme.color,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Tap to add image',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                ),
              ),

              // Conditional Fields
              if (_selectedType == 'mission') ...[
                SizedBox(height: 24),
                Text(
                  'Mission Statistics',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _heardCountController,
                        decoration: InputDecoration(labelText: 'Heard'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _hopeCountController,
                        decoration: InputDecoration(labelText: 'Hope'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        controller: _believedCountController,
                        decoration: InputDecoration(labelText: 'Believed'),
                        keyboardType: TextInputType.number,
                      ),
                    ),
                  ],
                ),
              ],

              SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submitPost,
                  child: _isLoading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('POST UPDATE'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
