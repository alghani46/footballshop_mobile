import 'dart:convert';

import 'package:flutter/material.dart';
import 'app_drawer.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameC = TextEditingController();
  final _priceC = TextEditingController();
  final _descC = TextEditingController();
  final _thumbC = TextEditingController();

  final _categories = const ['Shoes', 'Jersey', 'Ball', 'Accessory'];
  String? _selectedCategory;
  bool _isFeatured = false;

  @override
  void dispose() {
    _nameC.dispose();
    _priceC.dispose();
    _descC.dispose();
    _thumbC.dispose();
    super.dispose();
  }

  // ===== Validators =====
  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) return 'Name is required';
    final s = v.trim();
    if (s.length < 3) return 'Minimum 3 characters';
    if (s.length > 50) return 'Maximum 50 characters';
    return null;
  }

  String? _validatePrice(String? v) {
    if (v == null || v.trim().isEmpty) return 'Price is required';
    final parsed = double.tryParse(v.trim());
    if (parsed == null) return 'Price must be a number';
    if (parsed <= 0) return 'Price must be positive';
    return null;
  }

  String? _validateDescription(String? v) {
    if (v == null || v.trim().isEmpty) return 'Description is required';
    final s = v.trim();
    if (s.length < 10) return 'Minimum 10 characters';
    if (s.length > 500) return 'Maximum 500 characters';
    return null;
  }

  String? _validateCategory(String? v) {
    if (v == null || v.isEmpty) return 'Category is required';
    return null;
  }

  String? _validateThumbnail(String? v) {
    if (v == null || v.trim().isEmpty) return null; // optional
    final uri = Uri.tryParse(v.trim());
    final ok =
        uri != null && uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    if (!ok) return 'Thumbnail must be a valid http/https URL';
    if (v.length > 200) return 'URL too long (max 200 chars)';
    return null;
  }

  // ===== On Save: call Django API to create product =====
  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final request = context.read<CookieRequest>();

    final response = await request.postJson(
      // Flutter Web → localhost, not 10.0.2.2
      "http://localhost:8000/create-flutter/",
      jsonEncode({
        "name": _nameC.text.trim(),
        "price": _priceC.text.trim(),
        "description": _descC.text.trim(),
        "category": _selectedCategory ?? "",
        "thumbnail": _thumbC.text.trim(),
        "is_featured": _isFeatured,
      }),
    );

    if (!mounted) return;

    final messenger = ScaffoldMessenger.of(context)..hideCurrentSnackBar();

    if (response['status'] == 'success') {
      messenger.showSnackBar(
        const SnackBar(content: Text('Product created successfully')),
      );

      // Clear form
      _nameC.clear();
      _priceC.clear();
      _descC.clear();
      _thumbC.clear();
      setState(() {
        _selectedCategory = null;
        _isFeatured = false;
      });

      // Go to My Products page
      Navigator.pushReplacementNamed(context, '/my-products');
    } else {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Failed to create product: ${response['message'] ?? 'Unknown error'}',
          ),
        ),
      );
    }
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      drawer: const AppDrawer(currentRoute: '/add'),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: _nameC,
                decoration: const InputDecoration(
                  labelText: 'Name',
                  hintText: 'e.g. Adidas Predator 24',
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.next,
                validator: _validateName,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _priceC,
                decoration: const InputDecoration(
                  labelText: 'Price',
                  hintText: 'e.g. 129999',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: _validatePrice,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descC,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  hintText: 'Tell customers about this product',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: _validateDescription,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                items: _categories
                    .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedCategory = v),
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: _validateCategory,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _thumbC,
                decoration: const InputDecoration(
                  labelText: 'Thumbnail URL (optional)',
                  hintText: 'https://example.com/image.jpg',
                  border: OutlineInputBorder(),
                ),
                validator: _validateThumbnail,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                value: _isFeatured,
                title: const Text('Featured'),
                onChanged: (v) => setState(() => _isFeatured = v),
                subtitle: const Text('Mark this product as featured'),
              ),
              const SizedBox(height: 24),
              SizedBox(
                height: 56,
                child: FilledButton.icon(
                  icon: const Icon(Icons.save_outlined),
                  label: const Text('Save'),
                  onPressed: _onSave,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
