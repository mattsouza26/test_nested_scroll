import 'package:flutter/material.dart';
import 'package:test_nested_scroll/app/common/nested_scroll_physics.dart';

import '../controllers/home_controller.dart';

class NestedScrollPage extends StatefulWidget {
  final HomeController homeController;
  const NestedScrollPage({super.key, required this.homeController});
  @override
  State<NestedScrollPage> createState() => _NestedScrollPageState();
}

class _NestedScrollPageState extends State<NestedScrollPage> {
  late final ScrollController _nestedScrollController;
  late final ScrollController _listScrollController;

  @override
  void initState() {
    super.initState();
    widget.homeController.addListener(update);
    _nestedScrollController = ScrollController();
    _listScrollController = ScrollController();
  }

  update() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.homeController.removeListener(update);
    _nestedScrollController.dispose();
    _listScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        ElevatedButton(
          onPressed: () => _listScrollController.jumpTo(_listScrollController.position.maxScrollExtent),
          child: const Icon(Icons.vertical_align_bottom),
        ),
        ElevatedButton(
          onPressed: () => widget.homeController.addItem(),
          child: const Icon(Icons.add),
        ),
        ElevatedButton(
          onPressed: () => widget.homeController.removeItem(),
          child: const Icon(Icons.remove),
        ),
      ]),
      body: SafeArea(
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          // controller: _nestedScrollController,
          headerSliverBuilder: (context, inner) => [
            const SliverToBoxAdapter(
              child: SizedBox(height: 300, child: Placeholder()),
            )
          ],
          body: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
            child: ListView.builder(
              primary: false,
              physics: NestedScrollPhysics(context: context),
              itemCount: widget.homeController.value.length,
              controller: _listScrollController,
              itemBuilder: (context, index) => ListTile(
                title: Text("${widget.homeController.value[index]}"),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
