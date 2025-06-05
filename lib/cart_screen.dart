import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'shared_prefs.dart';
import 'custom_button.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    final cart = await SharedPrefs.getCart();
    setState(() => cartItems = cart);
  }

  Future<void> _updateQuantity(int index, int delta) async {
    final newQuantity = (cartItems[index]['quantity'] as int) + delta;
    if (newQuantity <= 0) {
      cartItems.removeAt(index);
    } else {
      cartItems[index]['quantity'] = newQuantity;
    }
    await SharedPrefs.saveCart(cartItems);
    setState(() {});
  }

  Future<void> _placeOrder() async {
    if (cartItems.isEmpty) return;
    final orders = await SharedPrefs.getOrders();
    orders.add({
      'items': cartItems,
      'total': cartItems.fold(
          0.0,
          (sum, item) =>
              sum +
              item['price'] * (1 - item['discount'] / 100) * item['quantity']),
      'date': DateTime.now().toIso8601String(),
    });
    await SharedPrefs.saveOrders(orders);
    await SharedPrefs.saveCart([]);
    setState(() => cartItems = []);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order placed', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF455A64),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = cartItems.fold(
        0.0,
        (sum, item) =>
            sum +
            item['price'] * (1 - item['discount'] / 100) * item['quantity']);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: cartItems.isEmpty
            ? Center(
                child: FadeIn(
                  child: Text(
                    'Your cart is empty',
                    style:
                        TextStyle(fontSize: 18, color: const Color(0xFF455A64)),
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  final discountedPrice =
                      item['price'] * (1 - item['discount'] / 100);
                  return FadeInUp(
                    delay: Duration(milliseconds: index * 100),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            item['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error),
                          ),
                        ),
                        title: Text(
                          item['name'],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF455A64),
                          ),
                        ),
                        subtitle: Text(
                          '\$${discountedPrice.toStringAsFixed(2)} x ${item['quantity']}',
                          style: const TextStyle(color: Color(0xFF455A64)),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle,
                                  color: Color(0xFF455A64)),
                              onPressed: () => _updateQuantity(index, -1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle,
                                  color: Color(0xFF455A64)),
                              onPressed: () => _updateQuantity(index, 1),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
      ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: FadeInUp(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Total: \$${total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF455A64),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomButton(text: 'Place Order', onPressed: _placeOrder),
                  ],
                ),
              ),
            ),
    );
  }
}
