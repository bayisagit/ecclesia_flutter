import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'screens/welcome_screen.dart';
import 'firebase_options.dart';
import 'providers/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // NOTE: You must configure Firebase for your platform (Android/iOS)
  // using the FlutterFire CLI or by adding google-services.json / GoogleService-Info.plist
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<User?>.value(
          value: AuthService().user,
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Ecclesia',
            themeMode: themeProvider.themeMode,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              scaffoldBackgroundColor: Colors.white,
              primaryColor: Colors.black,
              colorScheme: ColorScheme.light(
                primary: Colors.black,
                secondary: Color(0xFF6366F1), // Indigo accent
                surface: Colors.white,
                onSurface: Colors.black,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              textTheme: TextTheme(
                displayLarge: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                  letterSpacing: -1.0,
                ),
                displayMedium: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
                bodyLarge: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[800],
                  height: 1.6,
                ),
                bodyMedium: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[600],
                  height: 1.6,
                ),
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              scaffoldBackgroundColor: Color(0xFF0F172A), // Slate 900
              primaryColor: Colors.white,
              colorScheme: ColorScheme.dark(
                primary: Colors.white,
                secondary: Color(0xFF818CF8), // Indigo 400
                surface: Color(0xFF1E293B), // Slate 800
                onSurface: Colors.white,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Color(0xFF0F172A),
                elevation: 0,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              textTheme: TextTheme(
                displayLarge: TextStyle(
                  fontSize: 48.0,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                  letterSpacing: -1.0,
                ),
                displayMedium: TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
                bodyLarge: TextStyle(
                  fontSize: 18.0,
                  color: Colors.grey[300],
                  height: 1.6,
                ),
                bodyMedium: TextStyle(
                  fontSize: 16.0,
                  color: Colors.grey[400],
                  height: 1.6,
                ),
              ),
            ),
            home: WelcomeScreen(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
