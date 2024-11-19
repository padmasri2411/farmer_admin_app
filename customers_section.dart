import 'package:flutter/material.dart';

class CustomersSection extends StatefulWidget {
  const CustomersSection({super.key});

  @override
  State<CustomersSection> createState() => _CustomersSectionState();
}

class _CustomersSectionState extends State<CustomersSection> {
  // Sample data for customers
  final List<Map<String, String>> customers = [
    {'name': 'John Doe', 'email': 'john.doe@example.com', 'phone': '123-456-7890'},
    {'name': 'Jane Smith', 'email': 'jane.smith@example.com', 'phone': '234-567-8901'},
    {'name': 'Bob Johnson', 'email': 'bob.johnson@example.com', 'phone': '345-678-9012'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customers'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: customers.length,
          itemBuilder: (context, index) {
            final customer = customers[index];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              elevation: 4,
              child: ListTile(
                contentPadding: const EdgeInsets.all(16.0),
                title: Text(
                  customer['name']!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Email: ${customer['email']}'),
                    Text('Phone: ${customer['phone']}'),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
