import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/event_model.dart';
import '../services/database_service.dart';
import 'package:intl/intl.dart';

class EventDetailsScreen extends StatelessWidget {
  final EventModel event;
  final DatabaseService _db = DatabaseService();

  EventDetailsScreen({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(event.title),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Event Image
              Container(
                height: 200,
                width: double.infinity,
                color: Colors.grey[300],
                child: event.imageUrl.isNotEmpty
                    ? (event.imageUrl.startsWith('http')
                          ? Image.network(
                              event.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.broken_image,
                                  size: 100,
                                  color: Colors.grey[600],
                                );
                              },
                            )
                          : Image.asset(
                              event.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.broken_image,
                                  size: 100,
                                  color: Colors.grey[600],
                                );
                              },
                            ))
                    : Icon(Icons.image, size: 100, color: Colors.grey[600]),
              ),
              SizedBox(height: 20),
              Text(
                event.title,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 20, color: Colors.grey),
                  SizedBox(width: 10),
                  Text(DateFormat('yyyy-MM-dd').format(event.date)),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.location_on, size: 20, color: Colors.grey),
                  SizedBox(width: 10),
                  Text(event.location),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Description',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(event.description),
              SizedBox(height: 30),
              Text(
                'React to this Event',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildReactionButton(context, user, 'Like', Icons.thumb_up),
                  _buildReactionButton(context, user, 'Interested', Icons.star),
                  _buildReactionButton(
                    context,
                    user,
                    'Going',
                    Icons.check_circle,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReactionButton(
    BuildContext context,
    User? user,
    String label,
    IconData icon,
  ) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon),
          color: Colors.blueAccent,
          onPressed: () async {
            if (user != null) {
              await _db.addReaction(event.id, user.uid, label.toLowerCase());
              if (!context.mounted) return;
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Marked as $label')));
            } else {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Please login to react')));
            }
          },
        ),
        Text(label),
      ],
    );
  }
}
