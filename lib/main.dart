import 'package:farmer_admin_app/controllers/dashboard.controller.dart';
import 'package:farmer_admin_app/views/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
Future<void> main() async
{
  Get.put(DashboardController());
  runApp(MyApp());
}
class MyApp extends StatelessWidget  {
    const MyApp({super.key});
    @override
    Widget build(BuildContext context){
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Admin Dashboard",
        theme: ThemeData(useMaterial3: true),
        home: Dashboard(),
      );
    }
  }
