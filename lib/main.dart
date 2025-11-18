import 'package:flutter/material.dart';
import 'package:footballshop_mobile/app_drawer.dart';
import 'package:footballshop_mobile/add_product_form.dart';
import 'package:footballshop_mobile/screens/login.dart';
import 'package:footballshop_mobile/screens/product_list_page.dart';
import 'package:footballshop_mobile/screens/my_product_list.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<CookieRequest>(
      create: (_) => CookieRequest(),
      child: MaterialApp(
        title: 'Football Shop',
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSwatch(primarySwatch: Colors.blue)
              .copyWith(secondary: Colors.blueAccent[400]),
        ),
        // first screen
        home: const LoginPage(),
        routes: {
          '/home': (context) => const HomePage(),
          '/add': (context) => const AddProductPage(),
          '/products': (context) => const ProductListPage(),
          '/my-products': (context) => const MyProductListPage(),
        },
      ),
    );
  }
}

// ================= HOME =================

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Football Shop')),
      drawer: const AppDrawer(currentRoute: '/home'),
      body: const SafeArea(
        child: Center(
          child: ButtonsArea(),
        ),
      ),
    );
  }
}

// 3 big buttons in home
class ButtonsArea extends StatelessWidget {
  const ButtonsArea({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 30),

        // All Products
        SizedBox(
          width: 200,
          height: 50,
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, '/products'),
            child: const Text('All Products'),
          ),
        ),

        const SizedBox(height: 30),

        // My Products
        SizedBox(
          width: 200,
          height: 50,
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, '/my-products'),
            child: const Text('My Products'),
          ),
        ),

        const SizedBox(height: 30),

        // Add Product
        SizedBox(
          width: 200,
          height: 50,
          child: OutlinedButton(
            onPressed: () => Navigator.pushNamed(context, '/add'),
            child: const Text('Add Product'),
          ),
        ),
      ],
    );
  }
}
