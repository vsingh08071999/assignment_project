import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  double width;
  double height;
  LoadingWidget({required this.height, required this.width});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      child: Container(
          height: 40,
          width: 40,
          child: const CircularProgressIndicator(
            color: Colors.cyan,
          )),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.cyan, width: 2),
      ),
    );
  }
}
