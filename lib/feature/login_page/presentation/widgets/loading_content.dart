import 'package:flutter/material.dart';

/// Presents circular progress indicator in center
class LoadingContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}