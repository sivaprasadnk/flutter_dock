import 'package:flutter/material.dart';
import 'package:flutter_dock/dock_item.dart';

/// Dock of the reorderable [items].
class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    // required this.builder,
  });

  /// Initial [T] items to put in this [Dock].
  final List<T> items;

  /// Builder building the provided [T] item.
  // final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<T> _items = widget.items.toList();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _items.asMap().entries.map((e) {
          final item = e.value as IconData;
          return DockItem(icon: item);
        }).toList(),
      ),
    );
  }
}
