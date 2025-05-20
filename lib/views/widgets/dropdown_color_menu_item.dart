import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DropDownColorItem extends DropdownMenuItem<Color> {
  Color color;
  DropDownColorItem({required this.color})
      : super(
          child: Center(
              child: Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white), color: color),
          )),
          value: color,
        );
}
