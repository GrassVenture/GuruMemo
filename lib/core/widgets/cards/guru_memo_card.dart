import 'package:flutter/material.dart';

import '../../themes.dart';

class GuruMemoCard extends StatelessWidget {
  const GuruMemoCard({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Themes.gray[900]!),
      ),
      child: child,
    );
  }
}
