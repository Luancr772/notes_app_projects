import 'package:flutter/material.dart';

class Line extends StatelessWidget {
  const Line({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          child: Container(
            margin: const EdgeInsets.only(right: 10),
            width: 100,
            height: 1,
            color: Colors.white,
          ),
        ),
        const Text(
          'or',
          style: TextStyle(color: Colors.white),
        ),
        SizedBox(
          child: Container(
            margin: const EdgeInsets.only(left: 10),
            width: 100,
            height: 1,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
