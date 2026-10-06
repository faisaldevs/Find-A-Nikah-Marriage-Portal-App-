import 'package:flutter/material.dart';

/// Stand-in for a feature screen that hasn't been built yet — exists only so
/// the router has a widget to point at. Swap a route's builder for the real
/// `features/<name>/presentation` View as each one lands.
class PlaceholderScreen extends StatelessWidget {
  const PlaceholderScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title — coming soon')),
    );
  }
}
