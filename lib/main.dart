import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes_app/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("notesApp");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        tabBarTheme: TabBarTheme(
          indicatorColor: Colors.grey.shade700,
          dividerColor: Colors.transparent,
          labelColor: Colors.black,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.grey.shade400,
          foregroundColor: Colors.black,
        ),
        scaffoldBackgroundColor: Colors.grey.shade500,
      ),
      home: HomePage(),
    );
  }
}
