import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'database/local_storage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Transparent status & nav bars with dark icons for light theme
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.dark,
  ));
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  // Portrait only
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Preload both history and favorites caches so first access is instant
  await Future.wait([
    LocalStorage.loadHistory(),
    LocalStorage.loadFavorites(),
  ]);

  runApp(const NetCalcProApp());
}

class NetCalcProApp extends StatelessWidget {
  const NetCalcProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NetCalc Pro',
      debugShowCheckedModeBanner: false, // Explicitly strips away debug tag
      theme: AppTheme.darkTheme,         // Connects global visual layout configurations
      home: const SplashScreen(),       // Establishes custom launch timeline sequence
    );
  }
}
