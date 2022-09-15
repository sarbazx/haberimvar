import 'package:flutter/material.dart';

import 'initial_screen.dart';
import 'news_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.light,
        /* light theme settings */
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        /* dark theme settings */
      ),
      themeMode: ThemeMode.dark,
      title: 'HaberimVar',
      initialRoute: '/',
      routes: {
        '/': (context) => const InitialScreen(),
        '/news': (context) {
          final id = ModalRoute.of(context)?.settings.arguments as int;
          return NewsScreen(id: id);
        },
      },
    );
  }
}
