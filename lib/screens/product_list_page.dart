import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

import 'package:footballshop_mobile/app_drawer.dart';
import 'package:footballshop_mobile/models/product.dart';

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  late Future<List<ProductResponse>> _futureProducts;

  @override
  void initState() {
    super.initState();
    _futureProducts = _fetchProducts();
  }

  Future<List<ProductResponse>> _fetchProducts() async {
    final request = context.read<CookieRequest>();

    final response = await request.get(
      "http://localhost:8000/json/",
    );

    final jsonString = jsonEncode(response);
    return productResponseListFromJson(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Football Shop Products')),
      // <<< THIS is the important part
      drawer: const AppDrawer(currentRoute: '/products'),
      body: FutureBuilder<List<ProductResponse>>(
        future: _futureProducts,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          }

          final products = snapshot.data!;

          return ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final item = products[index];
              final p = item.fields;

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
                  onTap: () {
                    // navigate to detail page if you have it
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
