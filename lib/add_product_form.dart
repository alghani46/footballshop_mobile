import 'package:flutter/material.dart';
import 'app_drawer.dart';

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
    final ok = uri != null && uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    if (!ok) return 'Thumbnail must be a valid http/https URL';
    if (v.length > 200) return 'URL too long (max 200 chars)';
    return null;
  }

  // ===== On Save =====
  Future<void> _onSave() async {
    if (!_formKey.currentState!.validate()) return;

    final data = {
      'name': _nameC.text.trim(),
      'price': double.parse(_priceC.text.trim()),
      'description': _descC.text.trim(),
      'category': _selectedCategory,
      'is_featured': _isFeatured,
      'thumbnail': _thumbC.text.trim().isEmpty ? null : _thumbC.text.trim(),
    };

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Product Preview'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row('Name', data['name'].toString()),
              _row('Price', data['price'].toString()),
              _row('Description', data['description'].toString()),
              _row('Category', data['category'].toString()),
              _row('Is Featured', data['is_featured'].toString()),
              _row('Thumbnail', data['thumbnail']?.toString() ?? '-'),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: [
            TextSpan(text: '$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: value),
          ],
        ),
      ),
    );
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
                  hintText: 'e.g. 129.99',
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
