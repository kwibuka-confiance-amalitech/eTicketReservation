import 'package:flutter/material.dart';

class UserProfilePicture extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const UserProfilePicture(
      {required this.imageUrl, required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      foregroundColor: Colors.grey,
      radius: size,
      backgroundImage: imageUrl!.isEmpty ? null : NetworkImage(imageUrl!),
      child: imageUrl!.isEmpty
          ? Icon(
              Icons.account_circle_outlined,
              size: 2 * size,
            )
          : null,
    );
  }
}
