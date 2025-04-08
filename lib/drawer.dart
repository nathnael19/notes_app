import 'package:flutter/material.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({super.key});

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  @override
  Widget build(BuildContext context) {
    bool switchValue = false;
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Nathnael Nigussie"),
            currentAccountPicture: CircleAvatar(child: Icon(Icons.person)),
            accountEmail: Text("nathnaelnigussie19@gmail.com"),
          ),
          ListTile(
            onTap: () {},
            title: const Text("Home"),
            leading: const Icon(Icons.home_filled),
          ),

          ListTile(
            onTap: () {},
            title: const Text("About"),
            leading: const Icon(Icons.info_outline),
          ),
          ListTile(
            leading: Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            trailing: Switch(
              value: switchValue,
              onChanged: (value) {
                setState(() {
                  switchValue = !switchValue;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
