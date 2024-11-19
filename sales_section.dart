import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For date formatting

class SalesSection extends StatefulWidget {
  const SalesSection({super.key});

  @override
  State<SalesSection> createState() => _SalesSectionState();
}

class _SalesSectionState extends State<SalesSection> {
  // Sample sales data for different days
  final List<Map<String, dynamic>> salesData = [
    {
      'date': '2024-11-01',
      'totalSales': 1300.00,
      'orderCount': 30,
      'orders': [
        {'orderNumber': 'ORD12345', 'total': 500.00, 'items': 10},
        {'orderNumber': 'ORD12346', 'total': 700.00, 'items': 15},
        {'orderNumber': 'ORD12347', 'total': 100.00, 'items': 5},
      ],
    },
    {
      'date': '2024-11-02',
      'totalSales': 1500.00,
      'orderCount': 38,
      'orders': [
        {'orderNumber': 'ORD12348', 'total': 300.00, 'items': 8},
        {'orderNumber': 'ORD12349', 'total': 1200.00, 'items': 30},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Text(
            'Sales Overview',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16.0),

          // Sales data list
          Expanded(
            child: ListView.builder(
              itemCount: salesData.length,
              itemBuilder: (context, index) {
                final sale = salesData[index];
                return SalesCard(
                  date: sale['date'],
                  totalSales: sale['totalSales'],
                  orderCount: sale['orderCount'],
                  orders: sale['orders'],
                  onTap: () {
                    // Navigate to SalesDetailScreen when tapping on a sales day
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SalesDetailScreen(sale: sale),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SalesCard extends StatelessWidget {
  final String date;
  final double totalSales;
  final int orderCount;
  final List orders;
  final VoidCallback onTap;

  const SalesCard({
    required this.date,
    required this.totalSales,
    required this.orderCount,
    required this.orders,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Format date to a user-friendly format (e.g., Nov 1, 2024)
    final formattedDate = DateFormat('MMM dd, yyyy').format(DateTime.parse(date));

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date
              Text(
                formattedDate,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),

              // Total sales
              Text(
                'Total Sales: \$${totalSales.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8.0),

              // Order count
              Text(
                'Orders: $orderCount',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SalesDetailScreen extends StatelessWidget {
  final Map<String, dynamic> sale;

  const SalesDetailScreen({super.key, required this.sale});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales Details for ${sale['date']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display sales overview for the selected day
            Text(
              'Date: ${sale['date']}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Total Sales: \$${sale['totalSales'].toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.green),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Order Count: ${sale['orderCount']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
            const SizedBox(height: 16.0),

            // List of orders for the day
            Text(
              'Orders:',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Flexible(  // Wrap this in Flexible to avoid overflow
              child: ListView.builder(
                itemCount: sale['orders'].length,
                itemBuilder: (context, index) {
                  final order = sale['orders'][index];
                  return OrderDetailCard(
                    orderNumber: order['orderNumber'],
                    total: order['total'],
                    items: order['items'],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OrderDetailCard extends StatelessWidget {
  final String orderNumber;
  final double total;
  final int items;

  const OrderDetailCard({
    required this.orderNumber,
    required this.total,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order number
            Text(
              'Order: $orderNumber',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),

            // Total amount for this order
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.green),
            ),
            const SizedBox(height: 8.0),

            // Number of items in this order
            Text(
              'Items: $items',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
