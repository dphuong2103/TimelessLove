

import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget {
  final double value;
  const VerticalSpace(
    this.value, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: value,
    );
  }
}
