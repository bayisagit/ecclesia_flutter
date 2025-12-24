import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';
import '../services/database_service.dart';
import '../models/event_model.dart';
import '../models/user_model.dart';
import 'add_event_screen.dart';
import 'add_sermon_screen.dart';
import 'profile_screen.dart';
import 'contact_screen.dart';

// Import Sections
import 'home_sections/hero_section.dart';
import 'home_sections/about_section.dart';
import 'home_sections/ministries_section.dart';
import 'home_sections/sermons_section.dart';
import 'home_sections/events_section.dart';
import 'home_sections/annual_verses_section.dart';
import 'home_sections/devotional_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkForNewPosts();
    });
  }

  Future<void> _checkForNewPosts() async {
    final user = Provider.of<User?>(context, listen: false);
    if (user == null) return;

    final db = DatabaseService();
    // Get user data to check lastSeenPostDate
    final userDataStream = db.getUserData(user.uid);
    final userData = await userDataStream.first;

    // Get latest devotional post
    final postsStream = db.getDevotionalPosts();
    final posts = await postsStream.first;

    if (posts.isNotEmpty) {
      final latestPost = posts.first;
      if (userData.lastSeenPostDate == null ||
          latestPost.date.isAfter(userData.lastSeenPostDate!)) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('New posts available!'),
            action: SnackBarAction(
              label: 'Mark as Seen',
              onPressed: () {
                db.updateLastSeenPostDate(user.uid);
              },
            ),
            duration: const Duration(seconds: 10),
          ),
        );
      }
    }
  }

  final List<Widget> _pages = [
    SingleChildScrollView(
      child: Column(
        children: [
          HeroSection(),
          AnnualVersesSection(),
          DevotionalSection(),
          MinistriesSection(),
        ],
      ),
    ),
    SingleChildScrollView(child: AboutSection()),
    SingleChildScrollView(child: SermonsSection()),
    SingleChildScrollView(child: EventsSection()),
  ];

  void _onItemTapped(int index) {
    final user = Provider.of<User?>(context, listen: false);
    if (user != null) {
      if (index == 2) {
        // Sermons
        DatabaseService().updateLastViewed(user.uid, 'sermons');
      } else if (index == 3) {
        // Events
        DatabaseService().updateLastViewed(user.uid, 'events');
      }
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildBadgeIcon(
    BuildContext context,
    IconData icon,
    Stream<int> countStream,
  ) {
    return StreamBuilder<int>(
      stream: countStream,
      builder: (context, snapshot) {
        final count = snapshot.data ?? 0;
        return Stack(
          children: [
            Icon(icon),
            if (count > 0)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  constraints: BoxConstraints(minWidth: 12, minHeight: 12),
                  child: Text(
                    '$count',
                    style: TextStyle(color: Colors.white, fontSize: 8),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return StreamProvider<List<EventModel>>.value(
      value: DatabaseService().events,
      initialData: [],
      child: StreamBuilder<UserModel>(
        stream: user != null
            ? DatabaseService().getUserData(user.uid)
            : Stream.value(UserModel(uid: '', email: '', role: 'user')),
        builder: (context, userSnapshot) {
          final userModel = userSnapshot.data;

          return Scaffold(
            extendBodyBehindAppBar:
                _selectedIndex == 0, // Only extend for Home (Hero)
            appBar: AppBar(
              title: Text(
                'AASTU Focus',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              backgroundColor: _selectedIndex == 0 ? Colors.transparent : null,
              elevation: 0,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    Icons.person,
                    color: _selectedIndex == 0
                        ? Colors.white
                        : Theme.of(context).iconTheme.color,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ProfileScreen()),
                    );
                  },
                ),
              ],
            ),
            drawer: _buildDrawer(context, user),
            body: _pages[_selectedIndex],
            bottomNavigationBar: BottomNavigationBar(
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
                BottomNavigationBarItem(
                  icon: Icon(Icons.info),
                  label: 'About Us',
                ),
                BottomNavigationBarItem(
                  icon: _buildBadgeIcon(
                    context,
                    Icons.mic,
                    DatabaseService().getUnseenSermonsCount(
                      userModel?.lastViewedSermons,
                    ),
                  ),
                  label: 'Sermons',
                ),
                BottomNavigationBarItem(
                  icon: _buildBadgeIcon(
                    context,
                    Icons.event,
                    DatabaseService().getUnseenEventsCount(
                      userModel?.lastViewedEvents,
                    ),
                  ),
                  label: 'Events',
                ),
              ],
              currentIndex: _selectedIndex,
              selectedItemColor: Theme.of(context).colorScheme.secondary,
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
              type: BottomNavigationBarType.fixed,
            ),
            floatingActionButton: FutureBuilder<UserModel?>(
              future: Provider.of<AuthService>(
                context,
                listen: false,
              ).getUserDetails(user?.uid ?? ''),
              builder: (context, snapshot) {
                if (snapshot.hasData && snapshot.data!.role == 'admin') {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton(
                        heroTag: 'addSermon',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddSermonScreen(),
                            ),
                          );
                        },
                        backgroundColor: Theme.of(context).primaryColor,
                        tooltip: 'Add Sermon',
                        child: Icon(Icons.video_library),
                      ),
                      SizedBox(height: 10),
                      FloatingActionButton(
                        heroTag: 'addEvent',
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddEventScreen(),
                            ),
                          );
                        },
                        backgroundColor: Theme.of(
                          context,
                        ).colorScheme.secondary,
                        tooltip: 'Add Event',
                        child: Icon(Icons.event),
                      ),
                    ],
                  );
                }
                return Container();
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, User? user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              image: DecorationImage(
                image: AssetImage('assets/images/logo.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withValues(alpha: 0.3),
                  BlendMode.darken,
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'AASTU Focus',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  user?.email ?? 'Guest',
                  style: TextStyle(
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(0, 1),
                        blurRadius: 3.0,
                        color: Colors.black,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(0);
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About Us'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(1);
            },
          ),
          ListTile(
            leading: Icon(Icons.mic),
            title: Text('Sermons'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(2);
            },
          ),
          ListTile(
            leading: Icon(Icons.event),
            title: Text('Events'),
            onTap: () {
              Navigator.pop(context);
              _onItemTapped(3);
            },
          ),
          ListTile(
            leading: Icon(Icons.contact_mail),
            title: Text('Contact Us'),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ContactScreen()),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () async {
              bool confirm =
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Logout'),
                      content: const Text('Are you sure you want to logout?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Logout'),
                        ),
                      ],
                    ),
                  ) ??
                  false;

              if (confirm) {
                await Provider.of<AuthService>(
                  context,
                  listen: false,
                ).signOut();
              }
            },
          ),
        ],
      ),
    );
  }
}
