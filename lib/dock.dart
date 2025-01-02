import 'package:flutter/material.dart';
import 'package:flutter_dock/child_when_dragging.dart';
import 'package:flutter_dock/dock_item.dart';

class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    this.itemSpacing = 48.0, // New parameter for spacing
  });

  final List<IconData> items;

  /// Spacing between the dock items.
  final double itemSpacing;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T> extends State<Dock<T>> {
  late final List<IconData> _items = widget.items.toList();
  int? draggingItemIndex;
  int? hoveringItemIndex;

  Map<int, GlobalKey> itemKeys = {};

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _items.length; i++) {
      itemKeys[i] = GlobalKey();
    }
  }

  double calculateYValue({required int itemIndex}) {
    /// if any item is dragged or, when no item is hovered
    if (draggingItemIndex != null || hoveringItemIndex == null) {
      return 0;
    }

    /// absoulte value of distance between hovered-item and item
    final int distance = (hoveringItemIndex! - itemIndex).abs();
    const double firstNeighborMultiplier = 0.5;
    const double secondNeighborMultiplier = 0.25;
    const double distantNeighborMultiplier = 0.15;
    const double hoveredValue = -20;
    const double nearbyValue = -4;

    if (distance == 0) {
      return hoveredValue;
    } else if (distance == 1) {
      return (hoveredValue) * firstNeighborMultiplier;
    } else if (distance == 2) {
      return (hoveredValue) * secondNeighborMultiplier;
    } else if (distance < _items.length) {
      return (nearbyValue) * distantNeighborMultiplier;
    } else {
      return 0;
    }
  }

  /// to calculate how much the items to translate or move on x axis, or horizontally
  double calculateXValue({required int itemIndex}) {
    /// when no item is being dragged
    if (draggingItemIndex == null) {
      return 0;
    }

    /// if item is dragged, hovered over an index and item index <= index of item being dragged
    if (hoveringItemIndex != null && itemIndex <= hoveringItemIndex!) {
      return -30;
    }

    /// if item is dragged, hovered over an index and item index >= index of item being dragged
    if (hoveringItemIndex != null && itemIndex >= hoveringItemIndex!) {
      return 20;
    }
    return 0;
  }

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
        children: _items.asMap().entries.expand((e) {
          final index = e.key;
          final icon = e.value;
          return [
            MouseRegion(
              cursor: SystemMouseCursors.click,
              onEnter: (event) {
                setState(() {
                  hoveringItemIndex = index;
                });
              },
              onExit: (event) {
                setState(() {
                  hoveringItemIndex = null;
                });
              },
              child: DragTarget(
                onWillAcceptWithDetails: (details) {
                  setState(() {
                    draggingItemIndex =
                        _items.indexOf(details.data as IconData);
                  });
                  return draggingItemIndex != null &&
                      draggingItemIndex != hoveringItemIndex!;
                },
                onAcceptWithDetails: (details) {
                  setState(() {
                    _items.removeAt(draggingItemIndex!);
                    if (hoveringItemIndex == null) {
                      _items.insert(0, details.data as IconData);
                    } else {
                      if (hoveringItemIndex! < draggingItemIndex!) {
                        _items.insert(
                            hoveringItemIndex! + 1, details.data as IconData);
                      } else {
                        _items.insert(
                            hoveringItemIndex!, details.data as IconData);
                      }
                    }
                  });
                  draggingItemIndex = null;
                },
                builder: (context, candidateData, rejectedData) {
                  return Draggable(
                    data: icon,
                    childWhenDragging: ChildWhenDragging(),
                    onDraggableCanceled: (velocity, offset) {
                      setState(() {
                        draggingItemIndex = null;
                      });
                    },
                    feedback: Material(
                      color: Colors.transparent,
                      child: DockItem(
                        icon: icon,
                      ),
                    ),
                    child: AnimatedContainer(
                      key: itemKeys[index],
                      duration: const Duration(milliseconds: 300),
                      transform: Matrix4.identity()
                        ..translate(
                          calculateXValue(itemIndex: index),
                          calculateYValue(itemIndex: index),
                        ),
                      child: DockItem(icon: icon),
                    ),
                  );
                },
              ),
            ),
          ];
        }).toList(),
      ),
    );
  }
}
