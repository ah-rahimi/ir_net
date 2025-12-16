import 'package:flutter/material.dart';
import 'package:ir_net/theme/app_theme.dart';
import 'package:ir_net/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'home.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, _) {
          return MaterialApp(
            title: 'IRNet',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const HomePage(),
          );
        },
      ),
    );
  }
}
