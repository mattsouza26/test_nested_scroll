import 'package:flutter/material.dart';
import 'package:test_nested_scroll/app/common/nested_scroll_physics.dart';
import 'package:test_nested_scroll/app/screens/home/controllers/home_controller.dart';

class CustomScrollPage extends StatefulWidget {
  final HomeController homeController;
  const CustomScrollPage({super.key, required this.homeController});

  @override
  State<CustomScrollPage> createState() => _CustomScrollPageState();
}

class _CustomScrollPageState extends State<CustomScrollPage> {
  late final ScrollController _customScrollController;
  late final ScrollController _listScrollController;

  @override
  void initState() {
    super.initState();
    widget.homeController.addListener(update);
    _customScrollController = ScrollController();
    _listScrollController = ScrollController();
  }

  update() {
    setState(() {});
  }

  @override
  void dispose() {
    widget.homeController.removeListener(update);
    _customScrollController.dispose();
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
        child: CustomScrollView(
          physics: const NeverScrollableScrollPhysics(),
          scrollBehavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
          controller: _customScrollController,
          slivers: [
            const SliverToBoxAdapter(
              child: SizedBox(height: 300, child: Placeholder()),
            ),
            SliverFillRemaining(
              child: ScrollConfiguration(
                behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
                child: ListView.builder(
                  physics: NestedScrollPhysics(context: context, parentController: _customScrollController),
                  itemCount: widget.homeController.value.length,
                  controller: _listScrollController,
                  itemBuilder: (context, index) => ListTile(
                    title: Text("${widget.homeController.value[index]}"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
