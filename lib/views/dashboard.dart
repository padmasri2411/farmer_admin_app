import 'package:farmer_admin_app/controllers/dashboard.controller.dart';
import 'package:farmer_admin_app/views/widgets/customers_section.dart';
import 'package:farmer_admin_app/views/widgets/farmers_section.dart';
import 'package:farmer_admin_app/views/widgets/orders_section.dart';
import 'package:farmer_admin_app/views/widgets/products_section.dart';
import 'package:farmer_admin_app/views/widgets/sales_section.dart';
import 'package:farmer_admin_app/views/widgets/statistics_section.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Dashboard extends StatelessWidget {
  final DashboardController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Color(0xFFFFEBEE),
      body: screenWidth <= 600 // Mobile view layout
          ? _buildMobileLayout(context)
          : Row( // Desktop and tablet view layout
              children: [
                Obx(
                  () => AnimatedContainer(
                    width: controller.sidebarOpen.value ? 300 : 60,  // Expanded sidebar width
                    color: Colors.green,
                    duration: Duration(milliseconds: 300),
                    child: _buildSideBar(),
                  ),
                ),
                Expanded(
                  child: Container(
                    color: Colors.white,
                    child: Column(
                      children: [
                        _buildHeader(screenWidth),
                        Expanded(child: _buildContent()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }

  // Mobile layout with a Drawer for sidebar
  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome To Pure Harvest"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {}, // Implement logout functionality
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              child: Text(
                "Main Menu",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
            ),
            ...List.generate(controller.sections.length, (index) {
              return _buildSidebarItem(controller.sections[index].icon, controller.sections[index].title, index, context);
            }),
          ],
        ),
      ),
      body: _buildContent(),
    );
  }

  // Sidebar build for larger screens (desktop/tablet)
  Widget _buildSideBar() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "Main Menu",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Divider(color: Colors.white.withOpacity(0.3)),
        // Insert the image below the "Main Menu" heading
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Center(
            child: Image.asset(
              'C:/Users/SAI RAM/Desktop/pure_harvest.jpg', // Replace with your image path
              width: 100,  // Adjust the width as needed
              height: 100, // Adjust the height as needed
              fit: BoxFit.contain, // Ensures the image scales without distortion
            ),
          ),
        ),
        Divider(color: Colors.white.withOpacity(0.3)),
        Obx(
          () => Column(
            children: List.generate(
              controller.sections.length,
              (index) => _buildSidebarItem(
                controller.sections[index].icon,
                controller.sections[index].title,
                index,
                null, // No need to pass context for desktop/tablet
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Sidebar item widget with better visuals and animations
  Widget _buildSidebarItem(IconData icon, String title, int index, BuildContext? context) {
    return Obx(() {
      final isSelected = controller.currentSectionIndex.value == index;
      return GestureDetector(
        onTap: () {
          controller.changeSection(index);  // Change the section
          // Close the drawer on mobile when an item is clicked
          if (context != null) {
            Navigator.pop(context); // Close the drawer
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 200),
          color: isSelected ? Colors.white : Colors.green[700], // Change background color based on selection
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              SizedBox(width: 20),
              Icon(
                icon,
                size: 24,
                color: isSelected ? Colors.green : Colors.white,
              ),
              if (controller.sidebarOpen.value) SizedBox(width: 15),
              if (controller.sidebarOpen.value)
                Text(
                  title,
                  style: TextStyle(
                    color: isSelected ? Colors.green : Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }

  // Header with responsiveness and toggleable sidebar
  Widget _buildHeader(double screenWidth) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => controller.toggleSidebar(),
            child: Icon(Icons.menu, size: 30, color: Colors.green),
          ),
          SizedBox(width: 10),
          Text(
            "Welcome To Pure Harvest",
            style: TextStyle(
              fontSize: screenWidth > 600 ? 18 : 16, // Adjust font size based on screen width
              fontWeight: FontWeight.bold,
            ),
          ),
          Spacer(),
          Icon(
            Icons.logout,
            color: Colors.green,
            size: 30,
          ),
        ],
      ),
    );
  }

  // Content that changes based on the selected section
  Widget _buildContent() {
    return Obx(() {
      switch (controller.currentSectionIndex.value) {
        case 0:
          return StatisticsSection();
        case 1:
          return ProductsSection();
        case 2:
          return OrdersSection();
        case 3:
          return CustomersSection();
        case 4:
          return FarmersSection();
        case 5:
          return SalesSection();
        default:
          return Center(child: Text("Data Not Found"));
      }
    });
  }

}
