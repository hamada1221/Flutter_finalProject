import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:animate_do/animate_do.dart';
import 'shared_prefs.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Map<String, dynamic>> orders = [];

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final loadedOrders = await SharedPrefs.getOrders();
    setState(() => orders = loadedOrders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: orders.isEmpty
            ? Center(
                child: FadeIn(
                  child: Text(
                    'No orders yet',
                    style:
                        TextStyle(fontSize: 18, color: const Color(0xFF455A64)),
                  ),
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  final items = order['items'] as List;
                  final total = order['total'] as double;
                  final date = DateTime.parse(order['date']);
                  return FadeInUp(
                    delay: Duration(milliseconds: index * 100),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ExpansionTile(
                        backgroundColor: Colors.white,
                        collapsedBackgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                        title: Text(
                          'Order on ${DateFormat.yMMMd().format(date)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF455A64),
                          ),
                        ),
                        subtitle: Text(
                          'Total: \$${total.toStringAsFixed(2)}',
                          style: const TextStyle(color: Color(0xFF455A64)),
                        ),
                        children: items.map((item) {
                          final discountedPrice =
                              item['price'] * (1 - item['discount'] / 100);
                          return ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(Icons.error),
                              ),
                            ),
                            title: Text(
                              item['name'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF455A64),
                              ),
                            ),
                            subtitle: Text(
                              '\$${discountedPrice.toStringAsFixed(2)} x ${item['quantity']}',
                              style: const TextStyle(color: Color(0xFF455A64)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
