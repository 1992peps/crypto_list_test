import 'dart:math';

import 'package:flutter/material.dart';

Color rgbColorForIndex(int index) {
  final random = Random(index);
  final r = random.nextInt(256);
  final g = random.nextInt(256);
  final b = random.nextInt(256);
  return Color.fromARGB(255, r, g, b);
}

Color pastelForIndex(int index, {int opacity = 18}) {
  return rgbColorForIndex(index).withAlpha(opacity);
}
