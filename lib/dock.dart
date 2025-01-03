import 'package:flutter/material.dart';
import 'package:flutter_dock/child_when_dragging.dart';
import 'package:flutter_dock/dock_item.dart';

class Dock<T> extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
  });

  final List<IconData> items; // List of dock item icons

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

class _DockState<T> extends State<Dock<T>> {
  late List<IconData> _items;
  int? draggingItemIndex; // Index of the currently dragged item
  int? hoveringItemIndex; // Index of the hovered item

  Map<int, GlobalKey> itemKeys =
      {}; // Keys for each item to manage drag operations

  @override
  void initState() {
    super.initState();
    _items = widget.items; // Initialize items list from the widget
    // Assign a GlobalKey to each item to handle drag/drop actions
    for (int i = 0; i < _items.length; i++) {
      itemKeys[i] = GlobalKey();
    }
  }

  // Calculate the X translation for an item when dragging or hovering
  double _calculateXValue(int itemIndex) {
    if (draggingItemIndex == null) return 0; // No item is being dragged
    if (hoveringItemIndex == null) return 0; // No item is being hovered
    // Adjust translation based on dragging and hovering item positions
    if (itemIndex <= hoveringItemIndex!) return -30;
    if (itemIndex >= hoveringItemIndex!) return 20;
    return 0;
  }

  // Calculate the Y translation for an item based on its distance from the hovered item
  double _calculateYValue({
    required int itemIndex,
    required double baseValue,
    required double hoverValue,
    required double nonHoverValue,
  }) {
    if (hoveringItemIndex == null) return baseValue; // No item is hovered

    final distance = (hoveringItemIndex! - itemIndex)
        .abs(); // Calculate distance between hovered and current item

    // Interpolation logic for smooth value transitions
    double interpolate(double start, double end, double factor) {
      return start + (end - start) * factor;
    }

    // Return values based on proximity to the hovered item
    if (distance == 0) return hoverValue; // Hovered item
    if (distance == 1) {
      return interpolate(baseValue, hoverValue, 0.5); // Neighbors
    }
    if (distance == 2) {
      return interpolate(baseValue, hoverValue, 0.25); // 2nd neighbors
    }
    if (distance < 3 && distance <= _items.length) {
      return interpolate(baseValue, nonHoverValue, 0.15); // Close items
    }
    return baseValue; // Distant items
  }

  // Calculate the size of an item during hover or drag
  double _calculateSize(int itemIndex) {
    return _calculateYValue(
      itemIndex: itemIndex,
      baseValue: 68,
      hoverValue: 80,
      nonHoverValue: 48,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: _items.asMap().entries.expand((entry) {
          final index = entry.key;
          final icon = entry.value;

          return [
            Builder(
              builder: (context) {
                return MouseRegion(
                  cursor: SystemMouseCursors.click, // Change cursor on hover
                  onEnter: (_) => setState(
                      () => hoveringItemIndex = index), // Set hovered index
                  onExit: (_) => setState(
                      () => hoveringItemIndex = null), // Reset hovered index
                  child: DragTarget<IconData>(
                    onLeave: (_) => setState(() {
                      hoveringItemIndex =
                          null; // Reset when item is dragged out
                      draggingItemIndex = null; // Clear dragging state
                    }),
                    onWillAcceptWithDetails: (details) {
                      final draggedIndex = _items.indexOf(details.data);
                      setState(() {
                        hoveringItemIndex = index; // Set hovered index
                        draggingItemIndex =
                            draggedIndex; // Set dragged item index
                      });
                      return true; // Accept drag operation
                    },
                    onAcceptWithDetails: (details) {
                      final draggedIndex = _items.indexOf(details.data);
                      setState(() {
                        if (draggedIndex != -1) {
                          _items.removeAt(
                              draggedIndex); // Remove the dragged item
                          _items.insert(
                              index, details.data); // Insert at new position
                        }
                        draggingItemIndex = null; // Reset dragging state
                      });
                    },
                    builder: (context, candidateData, rejectedData) {
                      return Draggable<IconData>(
                        data: icon, // Pass data to the drag operation
                        childWhenDragging:
                            ChildWhenDragging(), // Show when item is being dragged
                        onDraggableCanceled: (_, __) => setState(() =>
                            draggingItemIndex =
                                null), // Reset dragging on cancel
                        feedback: Material(
                          color: Colors.transparent,
                          child: Transform.scale(
                            scale: 1.3, // Scale feedback item
                            child: DockItem(
                              icon: icon,
                              scale: _calculateSize(index) /
                                  68, // Scale based on hover/drag
                            ),
                          ),
                        ),
                        child: AnimatedContainer(
                          key: itemKeys[index], // Key for drag operations
                          duration: const Duration(milliseconds: 300),
                          transform: Matrix4.identity()
                            ..translate(
                              _calculateXValue(index), // Apply X translation
                              _calculateYValue(
                                itemIndex: index,
                                baseValue: 0,
                                hoverValue: -15,
                                nonHoverValue: -4,
                              ), // Apply Y translation
                            ),
                          margin: EdgeInsets.only(
                            left: draggingItemIndex != null &&
                                    hoveringItemIndex == index
                                ? 56
                                : 0,
                            right: draggingItemIndex != null &&
                                    hoveringItemIndex == index &&
                                    index == _items.length - 1
                                ? 40
                                : 0,
                          ),
                          constraints: BoxConstraints(
                            minWidth: 48,
                            maxWidth: _calculateSize(
                                index), // Set max width based on hover/drag size
                            maxHeight: _calculateSize(
                                index), // Set max height based on hover/drag size
                          ),
                          child: DockItem(
                            icon: icon,
                            scale: _calculateSize(index) /
                                68, // Scale the item based on its size
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ];
        }).toList(),
      ),
    );
  }
}
