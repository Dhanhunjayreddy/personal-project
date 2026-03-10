import 'package:flutter/material.dart';
import 'package:personal_project/providers/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';

import 'providers/auth_provider.dart';
import 'providers/post_provider.dart';
import 'screens/login_screen.dart';
import 'screens/posts_list_screen.dart';
import 'screens/connectivity_wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = GoogleFonts.interTextTheme();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Add this!
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'Posts App',
            debugShowCheckedModeBanner: false,

            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blueAccent,
                brightness: Brightness.light,
                background: const Color(0xFFF2F2F7),
              ),
              textTheme: textTheme,
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFFF2F2F7),
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.black),
                titleTextStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.blueAccent,
                brightness: Brightness.dark,
                background: const Color(0xFF000000),
              ),
              textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF000000),
                elevation: 0,
                scrolledUnderElevation: 0,
                centerTitle: true,
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            themeMode: themeProvider.themeMode,

            home: const ConnectivityWrapper(child: RootScreen()),
          );
        },
      ),
    );
  }
}

class RootScreen extends StatefulWidget {
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await context.read<AuthProvider>().checkAuthStatus();
    if (mounted) {
      setState(() => _isInitializing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator.adaptive()),
      );
    }

    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        return authProvider.isAuthenticated
            ? const PostsListScreen()
            : const LoginScreen();
      },
    );
  }
}
