import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final int value;
  final Widget childWidget;
  Badge(this.childWidget, this.value);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 10),
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          childWidget,
          Container(
            margin: const EdgeInsets.only(left: 25, bottom: 20),
            padding: const EdgeInsets.all(3),
            // color: Colors.amber,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.amber,
            ),
            child: Text(
              value.toString(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
