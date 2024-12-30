import 'package:flutter/material.dart';
import 'package:flutter_dock/dock_item.dart';

/// A customizable and reorderable dock widget.
///
/// The [Dock] widget displays a list of icons that can be dragged and rearranged
/// by the user. It provides visual feedback when items are hovered or dragged.
class Dock<T> extends StatefulWidget {
  /// Creates an instance of [Dock].
  ///
  /// The [items] parameter provides the initial list of items (icons) to be displayed.
  const Dock({
    super.key,
    this.items = const [],
  });

  /// Initial list of items to display in the dock.
  final List<IconData> items;

  @override
  State<Dock<T>> createState() => _DockState<T>();
}

/// State class for the [Dock] widget.
///
/// This manages the internal state of the dock, including drag and hover behaviors.
class _DockState<T> extends State<Dock<T>> {
  /// List of items currently displayed in the dock.
  ///
  /// Initialized from the [widget.items] and supports dynamic reordering.
  late final List<IconData> _items = widget.items.toList();

  /// Index of the item currently being dragged, or `null` if no drag is active.
  int? draggedItemIndex;

  /// Index of the item currently being hovered over, or `null` if no hover is active.
  int? hoveringItemIndex;

  /// Calculates the vertical adjustment for dock items based on their interaction state.
  ///
  /// This function determines how much an item should shift vertically when it is
  /// hovered or near a hovered item. The shift creates a dynamic, interactive effect.
  ///
  /// - [itemIndex]: The index of the current item.
  /// - [defaultValue]: The default vertical position for the item.
  /// - [hoveredValue]: The vertical position for the directly hovered item.
  /// - [nearbyValue]: The vertical position for items near the hovered item.
  ///
  /// Returns the calculated vertical position adjustment.
  double calculate({
    required int itemIndex,
    required double defaultValue,
    required double hoveredValue,
    required double nearbyValue,
  }) {
    if (hoveringItemIndex == null) {
      return defaultValue; // No hover, return default position.
    }

    final int distance = (hoveringItemIndex! - itemIndex).abs();
    const double firstNeighborMultiplier = 0.5;
    const double secondNeighborMultiplier = 0.25;
    const double distantNeighborMultiplier = 0.15;

    if (distance == 0) {
      return hoveredValue; // Directly hovered item.
    } else if (distance == 1) {
      return defaultValue +
          (hoveredValue - defaultValue) *
              firstNeighborMultiplier; // First neighbor.
    } else if (distance == 2) {
      return defaultValue +
          (hoveredValue - defaultValue) *
              secondNeighborMultiplier; // Second neighbor.
    } else if (distance < _items.length) {
      return defaultValue +
          (nearbyValue - defaultValue) *
              distantNeighborMultiplier; // Distant but affected.
    } else {
      return defaultValue; // Unaffected items.
    }
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
        children: _items.asMap().entries.map((e) {
          final index = e.key;
          final icon = e.value;
          return MouseRegion(
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
                final index = _items.indexOf(details.data as IconData);
                setState(() {
                  draggedItemIndex = index;
                });
                return true;
              },
              onAcceptWithDetails: (details) {
                final oldIndex = _items.indexOf(details.data as IconData);
                if (oldIndex != -1) {
                  setState(() {
                    _items.removeAt(oldIndex);
                    _items.insert(index, details.data as IconData);
                  });
                }
              },
              builder: (context, candidateData, rejectedData) {
                return Draggable(
                  data: icon,
                  childWhenDragging: TweenAnimationBuilder(
                    tween: Tween<double>(begin: 48, end: 0),
                    duration: const Duration(seconds: 1),
                    builder: (context, value, _) {
                      return SizedBox(
                        height: value,
                        width: value,
                      );
                    },
                  ),
                  feedback: Material(
                    color: Colors.transparent,
                    child: DockItem(
                      icon: icon,
                      // bottomMargin: 0,
                    ),
                  ),
                  child: AnimatedContainer(
                    duration: const Duration(seconds: 1),
                    transform: Matrix4.identity()
                      ..translate(
                        0,
                        calculate(
                          itemIndex: index,
                          defaultValue: 0,
                          hoveredValue: -20,
                          nearbyValue: -4,
                        ),
                      ),
                    child: DockItem(
                      icon: icon,
                      // bottomMargin: 0,
                    ),
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}
