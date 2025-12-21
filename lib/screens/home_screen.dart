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

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AuthService _auth = AuthService();
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    SingleChildScrollView(
      child: Column(children: [HeroSection(), MinistriesSection()]),
    ),
    SingleChildScrollView(child: AboutSection()),
    SingleChildScrollView(child: SermonsSection()),
    SingleChildScrollView(child: EventsSection()),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    return StreamProvider<List<EventModel>>.value(
      value: DatabaseService().events,
      initialData: [],
      child: Scaffold(
        extendBodyBehindAppBar:
            _selectedIndex == 0, // Only extend for Home (Hero)
        appBar: AppBar(
          title: Text(
            'Ecclesia',
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
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: 'About Us'),
            BottomNavigationBarItem(icon: Icon(Icons.mic), label: 'Sermons'),
            BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.secondary,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          type: BottomNavigationBarType.fixed,
        ),
        floatingActionButton: FutureBuilder<UserModel?>(
          future: AuthService().getUserDetails(user?.uid ?? ''),
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
                    child: Icon(Icons.video_library),
                    backgroundColor: Theme.of(context).primaryColor,
                    tooltip: 'Add Sermon',
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
                    child: Icon(Icons.event),
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    tooltip: 'Add Event',
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, User? user) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Ecclesia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  user?.email ?? 'Guest',
                  style: TextStyle(color: Colors.white70),
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
              await _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
