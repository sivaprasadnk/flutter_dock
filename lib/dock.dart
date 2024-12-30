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
  final List<IconData> items;

  /// Builder building the provided [T] item.
  // final Widget Function(T) builder;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState<T> extends State<Dock<T>> {
  /// [T] items being manipulated.
  late final List<IconData> _items = widget.items.toList();

  int? draggedItemIndex;

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
          final index = e.key;
          final icon = e.value;
          return DragTarget(
            onWillAcceptWithDetails: (details) {
              final index = _items.indexOf(details.data as IconData);
              setState(() {
                // _hoveredIndex = index;
                draggedItemIndex = index;
              });
              return true;
            },
            onAcceptWithDetails: (details) {
              final oldIndex = _items.indexOf(details.data as IconData);
              setState(() {
                _items.removeAt(oldIndex);
                _items.insert(index, details.data as IconData);
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Draggable(
                data: icon,
                childWhenDragging: SizedBox.shrink(),
                feedback: Material(
                  color: Colors.transparent,
                  child: DockItem(icon: icon),
                ),
                child: DockItem(icon: icon),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
