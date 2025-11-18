import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:footballshop_mobile/app_drawer.dart';
import 'package:footballshop_mobile/models/my_product.dart';

class MyProductListPage extends StatefulWidget {
  const MyProductListPage({super.key});

  @override
  State<MyProductListPage> createState() => _MyProductListPageState();
}

class _MyProductListPageState extends State<MyProductListPage> {
  late Future<List<MyProduct>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _fetchMyProducts();
  }

  Future<List<MyProduct>> _fetchMyProducts() async {
    final request = context.read<CookieRequest>();

    final response = await request.get(
      "http://localhost:8000/api/flutter/my-products/",
    );

    final jsonString = jsonEncode(response);
    return myProductListFromJson(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Products')),
      drawer: const AppDrawer(currentRoute: '/my-products'),
      body: FutureBuilder<List<MyProduct>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('You have no products yet.'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final p = products[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: p.thumbnail.isNotEmpty
                      ? Image.network(
                          p.thumbnail,
                          width: 56,
                          height: 56,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_not_supported),
                  title: Text(p.name),
                  subtitle: Text(
                    "${p.category} • Rp ${p.price}\n${p.description}",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: p.isFeatured
                      ? const Icon(Icons.star, color: Colors.amber)
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
