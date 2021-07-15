import 'package:flutter/material.dart';

class Progress {
  static indicator<Widget>() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: CircularProgressIndicator(),
      ),
    );
  }
}
