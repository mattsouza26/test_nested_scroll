import 'package:flutter/material.dart';

import '../controllers/home_controller.dart';

class SimpleScrollPage extends StatefulWidget {
  final HomeController homeController;
  const SimpleScrollPage({super.key, required this.homeController});

  @override
  State<SimpleScrollPage> createState() => _SimpleScrollPageState();
}

class _SimpleScrollPageState extends State<SimpleScrollPage> {
  late final ScrollController _listScrollController;

  @override
  void initState() {
    super.initState();
    widget.homeController.addListener(update);
    _listScrollController = ScrollController();
  }

  update() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.homeController.removeListener(update);
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ElevatedButton(
          onPressed: () => widget.homeController.addItem(),
          child: const Text("ADD"),
        ),
        ElevatedButton(
          onPressed: () => widget.homeController.removeItem(),
          child: const Text("Remove"),
        ),
      ]),
      body: SafeArea(
        child: ListView.builder(
          itemCount: widget.homeController.value.length,
          controller: _listScrollController,
          itemBuilder: (context, index) => ListTile(
            title: Text("${widget.homeController.value[index]}"),
          ),
        ),
      ),
    );
  }
}
