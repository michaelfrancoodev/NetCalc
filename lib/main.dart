import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme/app_theme.dart';
import 'theme/settings_manager.dart';
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

  // Preload history, favorites, and settings
  Future.wait([
    LocalStorage.loadHistory(),
    LocalStorage.loadFavorites(),
    SettingsManager().init(),
  ]);

  runApp(const NetCalcProApp());
}

class NetCalcProApp extends StatelessWidget {
  const NetCalcProApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: SettingsManager(),
      builder: (context, _) {
        final manager = SettingsManager();
        
        // Determine if we are effectively in dark mode to set system overlays
        final bool isDark = manager.themeMode == ThemeMode.dark || 
            (manager.themeMode == ThemeMode.system && 
             View.of(context).platformDispatcher.platformBrightness == Brightness.dark);

        // Update system overlay style dynamically
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
        ));

        return MaterialApp(
          title: 'NetCalc Pro',
          debugShowCheckedModeBanner: false,
          themeMode: manager.themeMode,
          theme: AppTheme.lightTheme.copyWith(
            colorScheme: AppTheme.lightTheme.colorScheme.copyWith(
              primary: manager.accentColor,
            ),
          ),
          darkTheme: AppTheme.darkTheme.copyWith(
            colorScheme: AppTheme.darkTheme.colorScheme.copyWith(
              primary: manager.accentColor,
            ),
          ),
          home: const SplashScreen(),
        );
      },
    );
  }
}
