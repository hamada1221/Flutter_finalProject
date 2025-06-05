import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'shared_prefs.dart';
import 'custom_button.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int _quantity = 1;

  Future<void> _addToCart(Map<String, dynamic> product) async {
    final cart = await SharedPrefs.getCart();
    final existing = cart.firstWhere(
      (item) => item['id'] == product['id'],
      orElse: () => {},
    );
    if (existing.isNotEmpty) {
      existing['quantity'] = (existing['quantity'] as int) + _quantity;
    } else {
      cart.add({...product, 'quantity': _quantity});
    }
    await SharedPrefs.saveCart(cart);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Added to cart', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF455A64),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final discountedPrice = product['price'] * (1 - product['discount'] / 100);

    return Scaffold(
      appBar: AppBar(
        title: Text(product['name']),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: FadeInUp(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(bottom: Radius.circular(24)),
                  child: Image.network(
                    product['image'],
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.error, size: 100),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF455A64),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '\$${discountedPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 24,
                          color: Color(0xFF455A64),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        product['description'],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF455A64),
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Color(0xFF455A64)),
                            onPressed: () => setState(() =>
                                _quantity = _quantity > 1 ? _quantity - 1 : 1),
                          ),
                          Text(
                            '$_quantity',
                            style: const TextStyle(
                                fontSize: 18, color: Color(0xFF455A64)),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle,
                                color: Color(0xFF455A64)),
                            onPressed: () => setState(() => _quantity++),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      CustomButton(
                        text: 'Add to Cart',
                        onPressed: () => _addToCart(product),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
