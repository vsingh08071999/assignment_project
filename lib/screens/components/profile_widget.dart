import 'dart:io';

import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  double width;
  double height;
  String profileUrl;
  ProfileWidget(
      {required this.height, required this.profileUrl, required this.width});

  @override
  Widget build(BuildContext context) {
    return profileUrl.isEmpty
        ? Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.cyan, width: 2),
              image: const DecorationImage(
                  image: ExactAssetImage('assets/profile_image.png'),
                  fit: BoxFit.fill),
            ),
          )
        : Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.cyan, width: 2),
              image: DecorationImage(
                  image: NetworkImage(profileUrl), fit: BoxFit.fill),
            ),
          );
  }
}
