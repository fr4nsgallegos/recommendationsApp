import 'package:flutter/material.dart';
import 'package:recommendationsapp/constants/constants.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.cyan.shade900,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                fondoBlanco(context, Container()),
              ],
            ),
          )
        ],
      ),
    );
  }
}
