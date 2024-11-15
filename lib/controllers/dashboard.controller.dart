import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SectionModel{
  final String title;
  final IconData icon;
  SectionModel({ required this.title, required this.icon});

}
class DashboardController extends GetxController{
  final RxInt currentSectionIndex=0.obs;
  final RxBool sidebarOpen=true.obs;
  final RxList<SectionModel> sections=<SectionModel>[
    SectionModel(title: "Dashboard", icon: Icons.dashboard),
    SectionModel(title: "Products", icon: Icons.shopping_bag),
    SectionModel(title: "Orders", icon: Icons.list_alt),
    SectionModel(title: "Customers", icon: Icons.people),
    SectionModel(title: "Farmer Details", icon: Icons.app_registration),
    SectionModel(title: "Sales", icon: Icons.attach_money),
].obs;

Future<List<Map<String, dynamic>>> fetchData() async{
  await Future.delayed(Duration(seconds:1));
  return List.generate(5, (index)=>{
    'productName': 'Product $index',
    'sales': '\$${(index + 1)*1000}',
    'stock': '${(index+1)*20} units',
    'category': 'Category $index',
    'dateAdded': '2024-10-15${index+1}',
    'totalRevenue':'\$${(index+1)*5000}',
    'averageOrderValue':'\$${(index+1)*50}',
    'customerCount':(index+1)*100,
  });
}

void changeSection(int index){
  currentSectionIndex.value=index;
}
void toggleSidebar(){
  sidebarOpen.value=!sidebarOpen.value;
}
}