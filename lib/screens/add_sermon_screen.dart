import 'package:flutter/material.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart';

class AddSermonScreen extends StatefulWidget {
  const AddSermonScreen({super.key});

  @override
  State<AddSermonScreen> createState() => _AddSermonScreenState();
}

class _AddSermonScreenState extends State<AddSermonScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _db = DatabaseService();

  String title = '';
  String speaker = '';
  String imageUrl = '';
  String videoUrl = '';
  DateTime date = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Sermon'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: InputDecoration(labelText: 'Sermon Title'),
                validator: (val) =>
                    val!.isEmpty ? 'Please enter a title' : null,
                onChanged: (val) => setState(() => title = val),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Speaker'),
                validator: (val) =>
                    val!.isEmpty ? 'Please enter a speaker name' : null,
                onChanged: (val) => setState(() => speaker = val),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Image URL'),
                validator: (val) =>
                    val!.isEmpty ? 'Please enter an image URL' : null,
                onChanged: (val) => setState(() => imageUrl = val),
              ),
              SizedBox(height: 20.0),
              TextFormField(
                decoration: InputDecoration(labelText: 'Video URL (YouTube)'),
                validator: (val) =>
                    val!.isEmpty ? 'Please enter a video URL' : null,
                onChanged: (val) => setState(() => videoUrl = val),
              ),
              SizedBox(height: 20.0),
              Row(
                children: [
                  Text('Date: ${DateFormat('yyyy-MM-dd').format(date)}'),
                  SizedBox(width: 20.0),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null && picked != date) {
                        setState(() {
                          date = picked;
                        });
                      }
                    },
                    child: Text('Select Date'),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Text(
                    'Create Sermon',
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await _db.addSermon(
                        title,
                        speaker,
                        date,
                        imageUrl,
                        videoUrl,
                      );
                      if (!context.mounted) return;
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Sermon added successfully!')),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
