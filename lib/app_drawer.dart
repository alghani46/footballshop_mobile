import 'package:flutter/material.dart';
import 'package:footballshop_mobile/screens/login.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;
  const AppDrawer({super.key, required this.currentRoute});

  void _go(BuildContext context, String routeName) {
    Navigator.pop(context); // close drawer
    if (routeName == currentRoute) return;
    Navigator.pushReplacementNamed(context, routeName);
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(fontSize: 24),
            ),
          ),

          // Home
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            selected: currentRoute == '/home',
            onTap: () => _go(context, '/home'),
          ),

          // All Products
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('All Products'),
            selected: currentRoute == '/products',
            onTap: () => _go(context, '/products'),
          ),

          // My Products
          ListTile(
            leading: const Icon(Icons.inventory_2),
            title: const Text('My Products'),
            selected: currentRoute == '/my-products',
            onTap: () => _go(context, '/my-products'),
          ),

          // Add Product
          ListTile(
            leading: const Icon(Icons.add_box_outlined),
            title: const Text('Add Product'),
            selected: currentRoute == '/add',
            onTap: () => _go(context, '/add'),
          ),

          const Divider(),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () async {
              final response = await request.logout(
                'http://localhost:8000/auth/logout/', // IMPORTANT: localhost for web
              );

              if (!context.mounted) return;

              if (response['status'] == true) {
                final uname = response['username'] ?? '';
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content:
                          Text('Logged out successfully. See you again, $uname.'),
                    ),
                  );

                // Clear stack & go to login screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginPage(),
                  ),
                  (route) => false,
                );
              } else {
                ScaffoldMessenger.of(context)
                  ..hideCurrentSnackBar()
                  ..showSnackBar(
                    SnackBar(
                      content:
                          Text(response['message'] ?? 'Logout failed.'),
                    ),
                  );
              }
            },
          ),
        ],
      ),
    );
  }
}
