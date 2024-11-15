import 'package:farmer_admin_app/controllers/dashboard.controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StatisticsSection extends StatefulWidget {
  const StatisticsSection({super.key});

  @override
  State<StatisticsSection> createState() => _StatisticsSectionState();
}

class _StatisticsSectionState extends State<StatisticsSection> {
  final DashboardController controller = Get.put(DashboardController());

  bool _ascending = true;
  String _sortColumn = 'sales';
  String _gilterCategory = "All";
  TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Dashboard Overview Title
            Text(
              "Dashboard Overview",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),

            // Dashboard Cards (Increased width)
            _buildDashboardCards(),
            SizedBox(height: 30),

            // Charts Row (responsive layout)
            _buildChartsRow(),
          ],
        ),
      ),
    );
  }

  // Build Dashboard Cards with flexible sizing
  Widget _buildDashboardCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Increase the width of the cards, making them wider for larger screens
        double cardWidth = constraints.maxWidth > 600
            ? (constraints.maxWidth - 40) / 2 // Two cards per row, more space per card
            : (constraints.maxWidth - 40) / 1.5; // On smaller screens, make cards wider (1.5 cards per row)

        // Ensure the cards have enough space between them
        return Wrap(
          alignment: WrapAlignment.start,
          spacing: 20,
          runSpacing: 20,
          children: [
            _buildCard("Total Revenue", "\$0", Icons.attach_money, Colors.greenAccent, cardWidth),
            _buildCard("Avg Order Revenue", "\$0", Icons.bar_chart, Colors.blueAccent, cardWidth),
            _buildCard("Total Customers", "\$0", Icons.people, Colors.purpleAccent, cardWidth),
            _buildCard("Total Products", "\$0", Icons.attach_money, Colors.orangeAccent, cardWidth),
          ],
        );
      },
    );
  }

  // Build Individual Card with flexible width
  Widget _buildCard(String title, String value, IconData icon, Color color, double cardWidth) {
    return Container(
      width: cardWidth, // Dynamically calculated width for each card
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 30,
                  color: color,
                ),
                SizedBox(width: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black.withOpacity(0.9),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Build the charts row with responsive layout
  Widget _buildChartsRow() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Depending on screen width, decide the number of charts in a row
        int chartCount = constraints.maxWidth > 600 ? 2 : 1; // If screen is large, show 2 charts in a row

        return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            for (int i = 0; i < chartCount; i++)
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: _buildLineChart(),
                ),
              ),
          ],
        );
      },
    );
  }

  // Build the Line Chart
  Widget _buildLineChart() {
    return _buildChartContainer(
      title: "Sales Trend",
      chart: LineChart(
        LineChartData(
          gridData: FlGridData(),
          lineBarsData: [
            LineChartBarData(
              spots: [FlSpot(0, 1), FlSpot(1, 3), FlSpot(2, 1.5)], // Example data points
              isCurved: true,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }

  // Container for the chart
  Widget _buildChartContainer({required String title, required Widget chart}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.2), blurRadius: 8)],
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              title,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 250, // Fixed height for the chart (can be made dynamic)
            child: chart,
          ),
        ],
      ),
    );
  }
}
