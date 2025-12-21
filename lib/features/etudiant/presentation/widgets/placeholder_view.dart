import 'package:flutter/material.dart';

class PlaceholderView extends StatelessWidget {
  final String title;

  const PlaceholderView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Contenu pour: $title',
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}
