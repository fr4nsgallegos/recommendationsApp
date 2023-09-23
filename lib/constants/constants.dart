import 'package:flutter/material.dart';

Widget fondoBlanco(BuildContext context, Widget child) {
  return Container(
    height: MediaQuery.of(context).size.height - 170.00,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(75.00),
      ),
    ),
    child: child,
  );
}
