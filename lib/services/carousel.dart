import 'package:flutter/material.dart';

class MyNotifier {
  final ValueNotifier<int> position;

  MyNotifier(this.position);

  changePos(pos) {
    position.value = pos;
  }
}
