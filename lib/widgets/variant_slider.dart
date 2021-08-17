import 'dart:math' as math;
import 'package:crate_and_barrel/constants.dart';
import 'package:crate_and_barrel/models/product_variant.dart';
import 'package:flutter/material.dart';

class VariantSlider extends StatefulWidget {
  final AnimationController slideController;
  final List<ProductVariant> productVariants;
  final ProductVariant selectedVariant;
  final Function(ProductVariant) onVariantSelected;
  const VariantSlider({
    Key? key,
    required this.slideController,
    required this.productVariants,
    required this.selectedVariant,
    required this.onVariantSelected,
  }) : super(key: key);

  @override
  State<VariantSlider> createState() => _VariantSliderState();
}

class _VariantSliderState extends State<VariantSlider>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  double offsetHeight = 700;

  @override
  void initState() {
    super.initState();
    _slideController = widget.slideController;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 420,
      child: AnimatedBuilder(
          animation: _slideController,
          builder: (context, child) {
            return Stack(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  height: 380,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(100)),
                    color: widget.selectedVariant.backgroundColor,
                  ),
                  width: 250,
                ),
                Positioned(
                  top: 180,
                  left: -30,
                  child: Image.asset(kLampLightImagePath), //Love this
                ),
                Stack(
                  children: [
                    for (int i = 0; i < widget.productVariants.length; i++)
                      Positioned(
                        top: 0,
                        left: -15,
                        child: Transform.rotate(
                          angle: _getLampAngle(i),
                          origin: Offset(0, -offsetHeight),
                          child: GestureDetector(
                            onHorizontalDragUpdate:
                                (DragUpdateDetails details) {
                              // print('Tapped $i');
                              _move(details);
                            },
                            onHorizontalDragEnd: _settle,
                            child: Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(
                                      widget.productVariants[i].image),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // color: Colors.red,
                              width: 350,
                              height: 350,
                              alignment: Alignment.center,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            );
          }),
    );
  }

  void _move(DragUpdateDetails details) {
    double delta = details.primaryDelta! / offsetHeight;
    double movementDegrees = -delta * (180 / math.pi);
    _slideController.value += movementDegrees;
  }

  void _settle(DragEndDetails details) {
    if (_slideController.isDismissed) return;
    int closestVariantIndex = _getClosestVariantIndex();
    widget.slideController
        .animateTo(closestVariantIndex * kSliderRotationAngle);
    widget.onVariantSelected(widget.productVariants[closestVariantIndex]);
  }

  int _getClosestVariantIndex() {
    double currentStopAngle = _slideController.value;
    List<double> lampStraightAngles = List.generate(
            widget.productVariants.length,
            (index) => index * kSliderRotationAngle)
        .toList(); // This is the extra angles needed for each lamp to be straight.

    double closestAngleToStopAngle = lampStraightAngles.reduce((prev, curr) =>
        ((curr - currentStopAngle).abs() < (prev - currentStopAngle).abs()
            ? curr
            : prev));

    int closestVariantIndex = lampStraightAngles
        .indexWhere((value) => value == closestAngleToStopAngle);
    return closestVariantIndex;
  }

  _getLampAngle(int lampIndex) {
    double lampAngle = (lampIndex * -kSliderRotationAngle * math.pi / 180) +
        (_slideController.value * math.pi / 180);
    return lampAngle;
  }
}
