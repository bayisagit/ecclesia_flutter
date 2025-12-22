import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ecclesia_flutter/models/user_model.dart';
import 'package:ecclesia_flutter/services/database_service.dart';
import '../../models/event_model.dart';
import '../event_details_screen.dart';

class EventsSection extends StatefulWidget {
  const EventsSection({super.key});

  @override
  State<EventsSection> createState() => _EventsSectionState();
}

class _EventsSectionState extends State<EventsSection> {
  bool _showAll = false;

  @override
  Widget build(BuildContext context) {
    final events = Provider.of<List<EventModel>>(context);

    // Sort events by date (soonest first)
    final sortedEvents = List<EventModel>.from(events);
    sortedEvents.sort((a, b) => a.date.compareTo(b.date));

    final displayedEvents = _showAll
        ? sortedEvents
        : sortedEvents.take(10).toList();

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      padding: EdgeInsets.symmetric(vertical: 60, horizontal: 20),
      child: Column(
        children: [
          Text(
            'UPCOMING EVENTS',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Join us in fellowship',
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 40),
          if (events.isEmpty)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text('No upcoming events scheduled.'),
            )
          else
            StreamBuilder<UserModel>(
              stream: FirebaseAuth.instance.currentUser != null
                  ? DatabaseService().getUserData(
                      FirebaseAuth.instance.currentUser!.uid,
                    )
                  : Stream.value(UserModel(uid: '', email: '', role: 'user')),
              builder: (context, userSnapshot) {
                final isAdmin = userSnapshot.data?.role == 'admin';
                return Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: displayedEvents.length,
                      itemBuilder: (context, index) {
                        return _buildEventCard(
                          context,
                          displayedEvents[index],
                          isAdmin,
                        );
                      },
                    ),
                    if (events.length > 10)
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0),
                        child: TextButton(
                          onPressed: () {
                            setState(() {
                              _showAll = !_showAll;
                            });
                          },
                          child: Text(
                            _showAll ? 'SHOW LESS' : 'SEE MORE',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, EventModel event, bool isAdmin) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark ? Colors.blueAccent : Colors.black12;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Container(
              height: 150,
              width: double.infinity,
              color: Colors.grey[300],
              child: Stack(
                children: [
                  event.imageUrl.isNotEmpty
                      ? (event.imageUrl.startsWith('http')
                            ? Image.network(
                                event.imageUrl,
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            : Image.asset(
                                event.imageUrl,
                                width: double.infinity,
                                height: 150,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.network(
                                    'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
                                    width: double.infinity,
                                    height: 150,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ))
                      : Image.network(
                          'https://images.unsplash.com/photo-1511795409834-ef04bbd61622?ixlib=rb-4.0.3&auto=format&fit=crop&w=500&q=60',
                          width: double.infinity,
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Column(
                        children: [
                          Text(
                            DateFormat('d').format(event.date),
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            DateFormat('MMM').format(event.date).toUpperCase(),
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isAdmin)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 16,
                        child: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red, size: 20),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Delete Event'),
                                content: Text(
                                  'Are you sure you want to delete this event?',
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      Navigator.pop(context);
                                      await DatabaseService().deleteEvent(
                                        event.id,
                                      );
                                    },
                                    child: Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    SizedBox(width: 5),
                    Text(
                      DateFormat('h:mm a').format(event.date),
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: [
                    Icon(
                      Icons.location_on,
                      size: 14,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        event.location,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EventDetailsScreen(event: event),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: borderColor),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      'EVENT DETAILS',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
