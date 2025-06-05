import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'constants.dart';

class ProductSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear, color: Color(0xFF455A64)),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back, color: Color(0xFF455A64)),
      onPressed: () => close(context, null),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = productData
        .where((product) =>
            product['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: results.length,
      itemBuilder: (context, index) {
        final product = results[index];
        final discountedPrice =
            product['price'] * (1 - product['discount'] / 100);
        return FadeInUp(
          delay: Duration(milliseconds: index * 100),
          child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  product['image'],
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error),
                ),
              ),
              title: Text(
                product['name'],
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF455A64),
                ),
              ),
              subtitle: Text(
                '\$${discountedPrice.toStringAsFixed(2)}',
                style: const TextStyle(color: Color(0xFF455A64)),
              ),
              onTap: () {
                close(context, null);
                Navigator.pushNamed(context, '/product', arguments: product);
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestions = productData
        .where((product) =>
            product['name'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          title: Text(
            product['name'],
            style: const TextStyle(color: Color(0xFF455A64)),
          ),
          onTap: () {
            query = product['name'];
            showResults(context);
          },
        );
      },
    );
  }
}
