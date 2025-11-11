import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute; 
  const AppDrawer({super.key, required this.currentRoute});

  void _go(BuildContext context, String routeName) {
    Navigator.pop(context); // close the drawer first
    if (routeName == currentRoute) return; // already here
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text('Menu', style: TextStyle(fontSize: 24)),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: currentRoute == '/',
            onTap: () => _go(context, '/'),
          ),
          ListTile(
            leading: const Icon(Icons.add_box_outlined),
            title: const Text('Add Product'),
            selected: currentRoute == '/add',
            onTap: () => _go(context, '/add'),
          ),
        ],
      ),
    );
  }
}
