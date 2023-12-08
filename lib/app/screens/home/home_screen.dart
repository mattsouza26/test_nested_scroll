import 'package:flutter/material.dart';
import 'package:test_nested_scroll/app/screens/home/controllers/home_controller.dart';
import 'package:test_nested_scroll/app/screens/home/pages/custom_scroll_page.dart';
import 'package:test_nested_scroll/app/screens/home/pages/nested_scroll_page.dart';
import 'package:test_nested_scroll/app/screens/home/pages/simple_scroll_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController _homeController = HomeController();

  @override
  void dispose() {
    _homeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Test for NestedScroll"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(width: double.infinity),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => SimpleScrollPage(
                    homeController: _homeController,
                  ),
                ),
              );
            },
            child: const Text("Simple Scroll Page"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NestedScrollPage(
                    homeController: _homeController,
                  ),
                ),
              );
            },
            child: const Text("Nested Scroll Page"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CustomScrollPage(
                    homeController: _homeController,
                  ),
                ),
              );
            },
            child: const Text("Custom Scroll Page"),
          )
        ],
      ),
    );
  }
}
