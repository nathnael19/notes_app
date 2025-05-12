import 'package:flutter/material.dart';
import 'package:notes_app/pages/about.dart';
import 'package:notes_app/utils/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    bool isDark = themeProvider.themeMode == ThemeMode.dark;
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Center(
              child: Text(
                'Debter',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
            },
            title: const Text("Home"),
            leading: const Icon(Icons.home_filled),
          ),

          SwitchListTile(
            title: Text("Dark Mode"),
            value: isDark,
            onChanged: (value) {
              themeProvider.toggleTheme(value);
            },
            secondary: Icon(Icons.dark_mode),
          ),
          ListTile(
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AboutPage()),
              );
            },
            title: const Text("About"),
            leading: const Icon(Icons.info_outline),
          ),
        ],
      ),
    );
  }
}
