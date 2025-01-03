import 'package:flutter/material.dart';

/// A widget representing an item in the dock.
class DockItem extends StatelessWidget {
  const DockItem({
    super.key,
    required this.icon, // Icon to display in the dock item
    required this.scale, // Scale factor for the icon's size
  });

  final IconData icon; // Icon to be displayed in the dock item
  final double scale; // Scale factor to adjust the icon's size

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
          minWidth: 48, minHeight: 48), // Ensure a minimum size for the item
      margin: const EdgeInsets.all(8), // Apply margin around the dock item
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(8), // Rounded corners for the dock item
        color: Colors.primaries[icon.hashCode %
            Colors.primaries.length], // Set a color based on the icon
      ),
      child: Center(
        child: Transform.scale(
          scale: scale, // Scale the icon based on the provided factor
          child: Icon(
            icon, // Display the icon passed to the widget
            color: Colors.white, // Set the icon color to white
          ),
        ),
      ),
    );
  }
}
