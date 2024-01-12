import 'package:flutter/material.dart';
import 'package:test_nested_scroll/app/common/nested_scroll_physics.dart';

import '../controllers/home_controller.dart';

class DefaultScrollPage extends StatefulWidget {
  final HomeController homeController;
  const DefaultScrollPage({super.key, required this.homeController});
  @override
  State<DefaultScrollPage> createState() => _DefaultScrollPageState();
}

class _DefaultScrollPageState extends State<DefaultScrollPage> {
  bool useController = false;
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
    _listScrollController.dispose();
    widget.homeController.removeListener(update);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
        Offstage(
          offstage: !useController,
          child: ElevatedButton(
            onPressed: () => _listScrollController.jumpTo(_listScrollController.position.maxScrollExtent),
            child: const Icon(Icons.vertical_align_bottom),
          ),
        ),
        ElevatedButton(
          onPressed: () => widget.homeController.addItem(),
          child: const Icon(Icons.add),
        ),
        ElevatedButton(
          onPressed: () => widget.homeController.removeItem(),
          child: const Icon(Icons.remove),
        ),
        Material(
          child: Switch(
              value: useController,
              onChanged: (value) {
                useController = value;
                setState(() {});
              }),
        ),
      ]),
      body: SafeArea(
        child: NestedScrollView(
          physics: const NeverScrollableScrollPhysics(),
          headerSliverBuilder: (context, inner) => [
            const SliverToBoxAdapter(
              child: SizedBox(height: 300, child: Placeholder()),
            )
          ],
          body: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
            child: ListView.builder(
              primary: false,
              physics: useController ? NestedScrollPhysics(context: context) : null,
              controller: useController ? _listScrollController : null,
              itemCount: widget.homeController.value.length,
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
