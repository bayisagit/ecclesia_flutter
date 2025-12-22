import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/ministry_post_model.dart';
import '../../services/database_service.dart';

class AddGlobalPostScreen extends StatefulWidget {
  const AddGlobalPostScreen({super.key});

  @override
  State<AddGlobalPostScreen> createState() => _AddGlobalPostScreenState();
}

class _AddGlobalPostScreenState extends State<AddGlobalPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _audioUrlController = TextEditingController();

  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  String _selectedType = 'devotional';
  bool _isLoading = false;

  final List<String> _types = ['devotional', 'annual_verse'];

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _audioUrlController.dispose();
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
          ministryName: 'Global', // Fixed for global posts
          title: _titleController.text,
          content: _contentController.text,
          imageUrl: imageUrl,
          audioUrl: _audioUrlController.text,
          date: DateTime.now(),
          type: _selectedType,
        );

        await DatabaseService().addMinistryPost(post);

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
      appBar: AppBar(title: Text('Add Global Content')),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DropdownButtonFormField<String>(
                initialValue: _selectedType,
                decoration: InputDecoration(labelText: 'Content Type'),
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
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: _selectedType == 'annual_verse'
                      ? 'Year (e.g. 2024)'
                      : 'Title',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a ${_selectedType == 'annual_verse' ? 'year' : 'title'}';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                decoration: InputDecoration(
                  labelText: _selectedType == 'annual_verse'
                      ? 'Verse Text'
                      : 'Content',
                ),
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter ${_selectedType == 'annual_verse' ? 'verse text' : 'content'}';
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
              if (_selectedType == 'devotional') ...[
                SizedBox(height: 16),
                TextFormField(
                  controller: _audioUrlController,
                  decoration: InputDecoration(
                    labelText: 'Audio URL (Optional)',
                  ),
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
                      : Text('POST CONTENT'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
