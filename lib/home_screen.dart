import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:animate_do/animate_do.dart';
import 'constants.dart';
import 'shared_prefs.dart';
import 'search_delegate.dart';
import 'custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String? userFirstName;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final firstName = await SharedPrefs.getFirstName();
    setState(() {
      userFirstName = firstName ?? 'User';
      print('HomeScreen loaded firstName: $userFirstName'); // Debug
    });
  }

  Future<void> _addToCart(Map<String, dynamic> product) async {
    final cart = await SharedPrefs.getCart();
    final cartItem = {
      'name': product['name'],
      'price': product['price'],
      'discount': product['discount'],
      'image': product['image'],
      'category': product['category'],
      'quantity': 1, // Default quantity
    };
    cart.add(cartItem);
    await SharedPrefs.saveCart(cart);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Added to cart!'), duration: Duration(seconds: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: Text('Welcome, $userFirstName'),
        // centerTitle: true,
        // backgroundColor: const Color(0xFF455A64),
        // foregroundColor: const Color(0xFFFFFFFF),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () =>
                showSearch(context: context, delegate: ProductSearchDelegate()),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FadeIn(
                child: CarouselSlider(
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: true,
                    viewportFraction: 0.9,
                  ),
                  items: productData.take(3).map((product) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: Image.network(
                        product['image'],
                        fit: BoxFit.cover,
                        width: double.infinity,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.error),
                      ),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF455A64),
                  ),
                ),
              ),
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    return FadeInRight(
                      delay: Duration(milliseconds: index * 100),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ActionChip(
                          label: Text(
                            category,
                            style: const TextStyle(color: Color(0xFF455A64)),
                          ),
                          backgroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                            side: const BorderSide(color: Color(0xFF455A64)),
                          ),
                          onPressed: () => Navigator.pushNamed(
                            context,
                            '/category',
                            arguments: category,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'New Arrivals',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF455A64),
                  ),
                ),
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.68, // Increased to fix overflow
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: productData.length > 6 ? 6 : productData.length,
                itemBuilder: (context, index) {
                  final product = productData[index];
                  final discountedPrice =
                      product['price'] * (1 - product['discount'] / 100);
                  return FadeInUp(
                    delay: Duration(milliseconds: index * 100),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: BorderSide(
                          color: const Color(0xFF455A64).withOpacity(0.2),
                          width: 1,
                        ),
                      ),
                      color: const Color(0xFFF7F7F7),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => Navigator.pushNamed(
                                  context, '/product',
                                  arguments: product),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                    child: Image.network(
                                      product['image'],
                                      height: 130,
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              const Icon(Icons.error),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product['name'],
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                            color: Color(0xFF455A64),
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          '\$${discountedPrice.toStringAsFixed(2)}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xFF455A64),
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        if (product['discount'] > 0)
                                          Text(
                                            '${product['discount']}% Off',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: const Color(0xFF455A64)
                                                  .withOpacity(0.8),
                                            ),
                                          ),
                                        
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: CustomButton(
                              text: 'Add to Cart',
                              onPressed: () => _addToCart(product),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFF455A64),
        selectedItemColor: const Color(0xFFFFFFFF),
        unselectedItemColor: const Color(0xFFB0BEC5),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Orders'),
        ],
        onTap: (index) {
          if (index == 1) Navigator.pushNamed(context, '/cart');
          if (index == 2) Navigator.pushNamed(context, '/orders');
        },
      ),
    );
  }
}
