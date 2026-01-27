import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/settings.dart';
import 'pages/pexels.dart';
import 'utils/api.dart';
import 'utils/uname.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => Username()),
        ChangeNotifierProvider(create: (_) => Api()),
        ChangeNotifierProvider(create: (_) => Avatar()),
      ],
      child: MaterialApp(
        routes: {'/settings': (context) => const Settings()},
        theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Poppins'),
        debugShowCheckedModeBanner: false,
        home: const Wallpaper(),
      ),
    );
  }
}
