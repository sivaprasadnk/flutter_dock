import 'package:flutter/material.dart';

class DockItem extends StatelessWidget {
  const DockItem({super.key, required this.icon});
  final IconData icon;
  @override
  Widget build(BuildContext context) {
    return DragTarget(
      onAcceptWithDetails: (details) {},
      builder: (context, candidateData, rejectedData) {
        return Draggable(
          data: icon,
          childWhenDragging: SizedBox.shrink(),
          feedback: Material(
            color: Colors.transparent,
            child: Container(
              constraints: const BoxConstraints(minWidth: 48),
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color:
                    Colors.primaries[icon.hashCode % Colors.primaries.length],
              ),
              child: Center(
                child: Icon(icon, color: Colors.white),
              ),
            ),
          ),
          child: Container(
            constraints: const BoxConstraints(minWidth: 48),
            height: 48,
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.primaries[icon.hashCode % Colors.primaries.length],
            ),
            child: Center(
              child: Icon(icon, color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
