import 'package:flutter/material.dart';

class ProductsSection extends StatefulWidget {
  const ProductsSection({super.key});

  @override
  State<ProductsSection> createState() => _ProductsSectionState();
}

class _ProductsSectionState extends State<ProductsSection> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Sample products data for each category
  final List<Map<String, dynamic>> vegetables = [
    {'name': 'Carrot', 'price': 2.99, 'image': 'https://via.placeholder.com/150'},
    {'name': 'Potato', 'price': 1.99, 'image': 'https://via.placeholder.com/150'},
    {'name': 'Cucumber', 'price': 3.49, 'image': 'https://via.placeholder.com/150'},
    {'name': 'Tomato', 'price': 4.99, 'image': 'https://via.placeholder.com/150'},
    {'name': 'Spinach', 'price': 2.59, 'image': 'https://via.placeholder.com/150'},
    {'name': 'Onion', 'price': 1.29, 'image': 'https://via.placeholder.com/150'},
  ];

  final List<Map<String, dynamic>> fruits = [
    {'name': 'Apple', 'price': 5.99, 'image': 'https://via.placeholder.com/150'},
    {'name': 'Banana', 'price': 3.29, 'image': 'https://via.placeholder.com/150'},
    {'name': 'Orange', 'price': 6.99, 'image': 'https://via.placeholder.com/150'},
    {'name': 'Grapes', 'price': 7.49, 'image': 'https://via.placeholder.com/150'},
    {'name': 'Pineapple', 'price': 6.49, 'image': 'https://via.placeholder.com/150'},
    {'name': 'Mango', 'price': 5.49, 'image': 'https://via.placeholder.com/150'},
  ];

  final List<Map<String, dynamic>> dairy = [
    {'name': 'Milk', 'price': 1.99, 'image': 'https://via.placeholder.com/150'},
    {'name': 'Cheese', 'price': 4.99, 'image': 'https://via.placeholder.com/150'},
    {'name': 'Yogurt', 'price': 2.99, 'image': 'https://via.placeholder.com/150'},
    {'name': 'Butter', 'price': 3.49, 'image': 'https://via.placeholder.com/150'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title with tab headers
          Text(
            'Products',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),
          
          // TabBar for category selection (Vegetables, Fruits, Dairy)
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Vegetables'),
              Tab(text: 'Fruits'),
              Tab(text: 'Dairy'),
            ],
            indicatorColor: Colors.green,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelStyle: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),

          // TabBarView to display content based on the selected tab
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Vegetables Tab
                ProductGridView(products: vegetables),
                // Fruits Tab
                ProductGridView(products: fruits),
                // Dairy Tab
                ProductGridView(products: dairy),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProductGridView extends StatelessWidget {
  final List<Map<String, dynamic>> products;

  const ProductGridView({required this.products});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,  // 2 items per row
        crossAxisSpacing: 16.0,  // Horizontal space between items
        mainAxisSpacing: 16.0,   // Vertical space between items
        childAspectRatio: 0.75,   // Adjust height of the item box for better fit
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(
          name: product['name'],
          price: product['price'],
          image: product['image'],
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tapped on ${product['name']}')),
            );
          },
        );
      },
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String image;
  final VoidCallback onTap;

  const ProductCard({
    required this.name,
    required this.price,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: Image.network(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image,
                      color: Colors.grey,
                      size: 50,
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product name
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4.0),
                  // Product price
                  Text(
                    '\$${price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
