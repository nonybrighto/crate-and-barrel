import 'package:crate_and_barrel/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CartIcon extends StatelessWidget {
  final bool hasNotification;
  final Color notificationColor;
  final int contentCount;
  const CartIcon({
    Key? key,
    this.notificationColor = Colors.redAccent,
    this.contentCount = 0,
    this.hasNotification = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: SvgPicture.asset(kCartIconPath),
          onPressed: () {},
        ),
        if (hasNotification)
          Positioned(
              top: 5,
              left: 30,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: notificationColor,
                  shape: BoxShape.circle,
                ),
              )),
        if (contentCount != 0)
          Positioned(
            top: 13,
            left: 23,
            child: Text('$contentCount'),
          )
      ],
    );
  }
}
