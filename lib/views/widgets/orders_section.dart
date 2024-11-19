import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Order Receipt Generator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const OrdersSection(),
    );
  }
}

class OrdersSection extends StatefulWidget {
  const OrdersSection({super.key});

  @override
  State<OrdersSection> createState() => _OrdersSectionState();
}

class _OrdersSectionState extends State<OrdersSection> {
  final List<Map<String, dynamic>> orders = [
    {
      'orderNumber': 'ORD12345',
      'items': [
        {'name': 'Product 1', 'image': 'https://via.placeholder.com/150', 'price': 49.99},
        {'name': 'Product 2', 'image': 'https://via.placeholder.com/150', 'price': 50.00},
      ],
      'total': 99.99,
      'status': 'Delivered',
      'customerName': 'John Doe',
      'customerAddress': '123 Main St, Springfield, IL',
      'customerPhone': '123-456-7890',
      'details': 'Order for customer A. Shipped via UPS.',
    },
    {
      'orderNumber': 'ORD12346',
      'items': [
        {'name': 'Product 3', 'image': 'https://via.placeholder.com/150', 'price': 75.00},
        {'name': 'Product 4', 'image': 'https://via.placeholder.com/150', 'price': 74.99},
      ],
      'total': 149.99,
      'status': 'Pending',
      'customerName': 'Jane Smith',
      'customerAddress': '456 Oak St, Chicago, IL',
      'customerPhone': '987-654-3210',
      'details': 'Order for customer B. Awaiting payment.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orders'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Orders',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  final order = orders[index];
                  return OrderCard(
                    orderNumber: order['orderNumber'],
                    items: order['items'],
                    total: order['total'],
                    status: order['status'],
                    customerName: order['customerName'],
                    customerAddress: order['customerAddress'],
                    customerPhone: order['customerPhone'],
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderDetailScreen(order: order),
                        ),
                      );
                    },
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

class OrderCard extends StatelessWidget {
  final String orderNumber;
  final List<Map<String, dynamic>> items;
  final double total;
  final String status;
  final String customerName;
  final String customerAddress;
  final String customerPhone;
  final VoidCallback onTap;

  const OrderCard({
    required this.orderNumber,
    required this.items,
    required this.total,
    required this.status,
    required this.customerName,
    required this.customerAddress,
    required this.customerPhone,
    required this.onTap,
  });

  // Method to generate the PDF receipt
  Future<void> _generateReceipt(BuildContext context) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text('Order Receipt', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Order Number: $orderNumber', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Customer: $customerName', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Address: $customerAddress', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Phone: $customerPhone', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 20),
              pw.Text('Status: $status', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 20),

              // Table for items
              pw.Table.fromTextArray(
                headers: ['Item Name', 'Price'],
                data: items.map((item) {
                  return [item['name'], '\$${item['price']}'];
                }).toList(),
                border: pw.TableBorder.all(),
                cellAlignment: pw.Alignment.center,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              ),

              pw.SizedBox(height: 20),
              pw.Text('Total: \$${total.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    // Preview the generated PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
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
              // Order number
              Text(
                'Order Number: $orderNumber',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8.0),

              // Customer info (name, address, phone)
              Text('Customer: $customerName'),
              Text('Address: $customerAddress'),
              Text('Phone: $customerPhone'),
              const SizedBox(height: 8.0),

              // Items list (showing product names and images)
              Column(
                children: items.take(2).map((item) {
                  return ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Image.network(
                      item['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item['name']),
                  );
                }).toList(),
              ),
              if (items.length > 2)
                Text(
                  '...and more',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
                ),
              const SizedBox(height: 8.0),

              // Total price
              Text(
                'Total: \$${total.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.green,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8.0),

              // Order status
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                decoration: BoxDecoration(
                  color: _getStatusColor(status),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Text(
                  status,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
              ),

              // Generate Receipt Button
              const SizedBox(height: 12.0),
              ElevatedButton(
                onPressed: () => _generateReceipt(context),
                child: const Text('Generate Receipt'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Get status color based on order status
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Delivered':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Shipped':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailScreen({super.key, required this.order});

  // Method to generate the PDF receipt
  Future<void> _generateReceipt(BuildContext context) async {
    final pdf = pw.Document();
    
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text('Order Receipt', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Order Number: ${order['orderNumber']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Customer: ${order['customerName']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Address: ${order['customerAddress']}', style: pw.TextStyle(fontSize: 16)),
              pw.Text('Phone: ${order['customerPhone']}', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 20),
              pw.Text('Status: ${order['status']}', style: pw.TextStyle(fontSize: 16)),
              pw.SizedBox(height: 20),

              // Table for items
              pw.Table.fromTextArray(
                headers: ['Item Name', 'Price'],
                data: order['items'].map((item) {
                  return [item['name'], '\$${item['price']}'];
                }).toList(),
                border: pw.TableBorder.all(),
                cellAlignment: pw.Alignment.center,
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration: pw.BoxDecoration(color: PdfColors.grey300),
              ),

              pw.SizedBox(height: 20),
              pw.Text('Total: \$${order['total'].toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ],
          );
        },
      ),
    );

    // Preview the generated PDF
    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Number: ${order['orderNumber']}',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Customer: ${order['customerName']}',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              'Address: ${order['customerAddress']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              'Phone: ${order['customerPhone']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Items:',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            // Display product names and images
            for (var item in order['items'])
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    Image.network(
                      item['image'],
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      item['name'],
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 16.0),
            Text(
              'Total: \$${order['total'].toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.green),
            ),
            const SizedBox(height: 16.0),
            Text(
              'Status: ${order['status']}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 16.0),
            Text(
              'Details: ${order['details']}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic),
            ),
            
            // Generate Receipt Button
            const SizedBox(height: 12.0),
            ElevatedButton(
              onPressed: () => _generateReceipt(context),
              child: const Text('Generate Receipt'),
            ),
          ],
        ),
      ),
    );
  }
}
