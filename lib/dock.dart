// import 'package:flutter/material.dart';
// import 'package:flutter_dock/child_when_dragging.dart';
// import 'package:flutter_dock/dock_item.dart';

// class Dock<T> extends StatefulWidget {
//   const Dock({
//     super.key,
//     this.items = const [],
//   });

//   final List<IconData> items;

//   @override
//   State<Dock<T>> createState() => _DockState<T>();
// }

// class _DockState<T> extends State<Dock<T>> {
//   late final List<IconData> _items = widget.items.toList();
//   int? draggedItemIndex;
//   int? hoveringItemIndex;

//   Map<int, GlobalKey> itemKeys = {};

//   @override
//   void initState() {
//     super.initState();
//     for (int i = 0; i < _items.length; i++) {
//       itemKeys[i] = GlobalKey();
//     }
//   }

//   double calculate({
//     required int itemIndex,
//     required double defaultValue,
//     required double hoveredValue,
//     required double nearbyValue,
//   }) {
//     if (hoveringItemIndex == null) {
//       return defaultValue;
//     }

//     final int distance = (hoveringItemIndex! - itemIndex).abs();
//     const double firstNeighborMultiplier = 0.5;
//     const double secondNeighborMultiplier = 0.25;
//     const double distantNeighborMultiplier = 0.15;

//     if (distance == 0) {
//       return hoveredValue;
//     } else if (distance == 1) {
//       return defaultValue +
//           (hoveredValue - defaultValue) * firstNeighborMultiplier;
//     } else if (distance == 2) {
//       return defaultValue +
//           (hoveredValue - defaultValue) * secondNeighborMultiplier;
//     } else if (distance < _items.length) {
//       return defaultValue +
//           (nearbyValue - defaultValue) * distantNeighborMultiplier;
//     } else {
//       return defaultValue;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8),
//         color: Colors.black12,
//       ),
//       padding: const EdgeInsets.all(4),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: _items.asMap().entries.map((e) {
//           final index = e.key;
//           final icon = e.value;

//           return MouseRegion(
//             cursor: SystemMouseCursors.click,
//             onEnter: (event) {
//               setState(() {
//                 hoveringItemIndex = index;
//               });
//             },
//             onExit: (event) {
//               setState(() {
//                 hoveringItemIndex = null;
//               });
//             },
//             child: DragTarget(
//               onWillAcceptWithDetails: (details) {
//                 setState(() {
//                   draggedItemIndex = _items.indexOf(details.data as IconData);
//                 });
//                 return true;
//               },
//               onAcceptWithDetails: (details) {
//                 final oldIndex = _items.indexOf(details.data as IconData);
//                 if (oldIndex != -1) {
//                   setState(() {
//                     _items.removeAt(oldIndex);
//                     _items.insert(index, details.data as IconData);
//                   });
//                 }
//               },
//               builder: (context, candidateData, rejectedData) {
//                 return Draggable(
//                   data: icon,

//                   childWhenDragging: ChildWhenDragging(),
//                   onDraggableCanceled: (velocity, offset) {
//                     setState(() {
//                       draggedItemIndex = null;
//                     });
//                   },
//                   feedback: Material(
//                     color: Colors.transparent,
//                     child: DockItem(
//                       icon: icon,
//                     ),
//                   ),
//                   child: AnimatedContainer(
//                     key: itemKeys[index],
//                     duration: const Duration(seconds: 1),
//                     transform: Matrix4.identity()
//                       ..translate(
//                         0,
//                         calculate(
//                           itemIndex: index,
//                           defaultValue: 0,
//                           hoveredValue: -20,
//                           nearbyValue: -4,
//                         ),
//                       ),
//                     child: DockItem(
//                       icon: icon,
//                     ),
//                   ),
//                 );
//               },
//             ),
//           );
//         }).toList(),
//       ),
//     );
//   }
// }

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
  int? draggedItemIndex1;
  int? hoveringItemIndex;

  Map<int, GlobalKey> itemKeys = {};

  Offset? dragOffset;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _items.length; i++) {
      itemKeys[i] = GlobalKey();
    }
  }

  double calculate({
    required int itemIndex,
    required double defaultValue,
    required double hoveredValue,
    required double nearbyValue,
  }) {
    if (hoveringItemIndex == null) {
      return defaultValue;
    }

    final int distance = (hoveringItemIndex! - itemIndex).abs();
    const double firstNeighborMultiplier = 0.5;
    const double secondNeighborMultiplier = 0.25;
    const double distantNeighborMultiplier = 0.15;

    if (distance == 0) {
      return hoveredValue;
    } else if (distance == 1) {
      return defaultValue +
          (hoveredValue - defaultValue) * firstNeighborMultiplier;
    } else if (distance == 2) {
      return defaultValue +
          (hoveredValue - defaultValue) * secondNeighborMultiplier;
    } else if (distance < _items.length) {
      return defaultValue +
          (nearbyValue - defaultValue) * distantNeighborMultiplier;
    } else {
      return defaultValue;
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
                onMove: (details) {
                  draggedItemIndex1 = _items.indexOf(details.data as IconData);
                  debugPrint("## draggedItemIndex1 $draggedItemIndex1");
                  setState(() {});
                },
                onWillAcceptWithDetails: (details) {
                  setState(() {
                    draggingItemIndex =
                        _items.indexOf(details.data as IconData);
                  });
                  return draggingItemIndex != index;
                },
                onAcceptWithDetails: (details) {
                  final oldIndex = _items.indexOf(details.data as IconData);
                  if (oldIndex != -1) {
                    setState(() {
                      _items.removeAt(oldIndex);
                      _items.insert(index, details.data as IconData);
                    });
                  }
                  draggingItemIndex = null;
                },
                builder: (context, candidateData, rejectedData) {
                  return Draggable(
                    data: icon,
                    childWhenDragging: ChildWhenDragging(),
                    onDraggableCanceled: (velocity, offset) {
                      setState(() {
                        dragOffset = offset;
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

                      /// todo to translate by taking hovering index into consideration
                      /// and translate x axis
                      ///
                      transform: Matrix4.identity()
                        ..translate(
                          draggingItemIndex == null
                              ? 0
                              : hoveringItemIndex != null &&
                                      index == hoveringItemIndex
                                  ? -30
                                  : hoveringItemIndex != null &&
                                          index == hoveringItemIndex! + 1
                                      ? 30
                                      : 0,
                          calculate(
                            itemIndex: index,
                            defaultValue: 0,
                            hoveredValue: -20,
                            nearbyValue: -4,
                          ),
                        ),
                      child: hoveringItemIndex != null &&
                              draggingItemIndex != null &&
                              hoveringItemIndex == index
                          ? SizedBox(
                              width: 48,
                              height: 48,
                            )
                          : DockItem(
                              icon: icon,
                            ),
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
