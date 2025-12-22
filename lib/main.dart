import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'services/auth_service.dart';
import 'screens/wrapper.dart';
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
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(create: (_) => AuthService()),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().user,
          initialData: null,
        ),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'AASTU Focus',
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
              iconTheme: IconThemeData(color: Colors.black),
              cardTheme: CardThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.black12, width: 1),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.black, width: 2),
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
                iconTheme: IconThemeData(color: Colors.blueAccent),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              iconTheme: IconThemeData(color: Colors.blueAccent),
              cardTheme: CardThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: Colors.blueAccent, width: 1),
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blueAccent, width: 2),
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
            home: Wrapper(),
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
