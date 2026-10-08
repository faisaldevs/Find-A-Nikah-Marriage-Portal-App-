import 'package:flutter/material.dart';

/// Stand-in for a feature screen that hasn't been built yet — exists only so
/// the router has a widget to point at. Swap a route's builder for the real
/// `features/<name>/presentation` View as each one lands.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title — coming soon')),
    );
  }
}
