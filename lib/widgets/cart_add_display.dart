import 'package:crate_and_barrel/constants.dart';
import 'package:crate_and_barrel/models/product_variant.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class CartAddDisplay extends StatefulWidget {
  final AnimationController animationController;
  final int itemCount;
  final Offset colorButtonPosition;
  final Offset cartIconPosition;
  final ProductVariant selectedVariant;
  const CartAddDisplay({
    Key? key,
    required this.animationController,
    this.itemCount = 0,
    required this.colorButtonPosition,
    required this.cartIconPosition,
    required this.selectedVariant,
  }) : super(key: key);

  @override
  _CartAddDisplayState createState() => _CartAddDisplayState();
}

class _CartAddDisplayState extends State<CartAddDisplay> {
  late double buttonExpansionEnd;
  late Animation<double> buttonExpandAnimation;
  late Animation<double> buttonCollapseAnimation;
  late Animation<double> textSlideInAnimation;
  late Animation<double> textSlideOutAnimation;
  @override
  void initState() {
    super.initState();

    buttonExpandAnimation = Tween(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          0.0,
          _getInterval(600),
          curve: Curves.easeIn,
        )));
    buttonCollapseAnimation = Tween(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          _getInterval(800),
          1.0,
          curve: Curves.easeOut,
        )));

    textSlideInAnimation = Tween(
      begin: 50.0,
      end: 0.0,
    ).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          0.0,
          _getInterval(600),
          curve: Curves.fastLinearToSlowEaseIn,
        )));
    textSlideOutAnimation = Tween(
      begin: 0.0,
      end: -50.0,
    ).animate(CurvedAnimation(
        parent: widget.animationController,
        curve: Interval(
          _getInterval(800),
          1.0,
          curve: Curves.fastLinearToSlowEaseIn,
        )));

    _calculateExpansionEnd();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedBuilder(
            animation: widget.animationController,
            builder: (context, child) {
              final collapseStart = _getInterval(800);
              bool collapse = widget.animationController.value > collapseStart;

              double containerSize = kColorButtonSize +
                  buttonExpansionEnd *
                      (collapse
                          ? buttonCollapseAnimation.value
                          : buttonExpandAnimation.value);
              double leftPoint = collapse
                  ? widget.cartIconPosition.dx + 25
                  : widget.colorButtonPosition.dx;
              double topPoint = collapse
                  ? widget.cartIconPosition.dy + 25
                  : widget.colorButtonPosition.dy;
              return Positioned(
                left: leftPoint - containerSize / 2,
                top: topPoint - containerSize / 2,
                child: Container(
                  width: containerSize,
                  height: containerSize,
                  alignment: collapse ? Alignment.center : Alignment.topRight,
                  decoration: BoxDecoration(
                    color: widget.selectedVariant.color,
                    shape: BoxShape.circle,
                  ),
                ),
              );
            }),
        _buildTextAnimationDisplay(),
      ],
    );
  }

  Widget _buildTextAnimationDisplay() {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: AnimatedBuilder(
            animation: widget.animationController,
            builder: (context, child) {
              final reverseStart = _getInterval(800);
              bool reverse = widget.animationController.value > reverseStart;

              double translationPosition = reverse
                  ? textSlideOutAnimation.value
                  : textSlideInAnimation.value;
              return ClipPath(
                clipper: TextClipPath(),
                child: Container(
                  color: Colors.transparent,
                  child: Transform.translate(
                    offset: Offset(0, translationPosition),
                    child: Text(
                      '${widget.itemCount} ${widget.selectedVariant.name} item${widget.itemCount > 1 ? 's' : ''} added',
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }

  _calculateExpansionEnd() {
    double cartIconColorbuttonDistance = math.sqrt(
      math.pow(widget.cartIconPosition.dx - widget.colorButtonPosition.dx, 2) +
          math.pow(
              widget.cartIconPosition.dy - widget.colorButtonPosition.dy, 2),
    );

    buttonExpansionEnd = (cartIconColorbuttonDistance * 2) + 100;
    // add 100 to cover up for extra space. Mediaquery width can be used instead :-)
  }

  double _getInterval(double timeInmilliseconds) {
    return timeInmilliseconds / kCartAddDurationInMs;
  }
}

class TextClipPath extends CustomClipper<Path> {
  var radius = 10.0;
  @override
  Path getClip(Size size) {
    Path path = Path()
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..lineTo(size.width, 0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
