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
                    backgroundColor: Theme.of(context).colorScheme.secondary,
                    tooltip: 'Add Event',
                    child: Icon(Icons.event),
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
              await Provider.of<AuthService>(context, listen: false).signOut();
            },
          ),
        ],
      ),
    );
  }
}
