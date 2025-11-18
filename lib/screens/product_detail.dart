import 'package:flutter/material.dart';
import 'package:footballshop_mobile/models/product.dart';

class ProductDetailPage extends StatelessWidget {
  final ProductResponse product;

  const ProductDetailPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final p = product.fields;

    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (p.thumbnail.isNotEmpty)
                Center(
                  child: Image.network(
                    p.thumbnail,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),
              const SizedBox(height: 16),
              Text(
                p.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text("Category: ${p.category}"),
              const SizedBox(height: 4),
              Text("Price: Rp ${p.price}"),
              const SizedBox(height: 4),
              Text("Featured: ${p.isFeatured ? "Yes" : "No"}"),
              const SizedBox(height: 16),
              const Text(
                "Description",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(p.description),
              const SizedBox(height: 24),
              Center(
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Back to list"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
