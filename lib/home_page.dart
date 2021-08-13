import 'package:crate_and_barrel/constants.dart';
import 'package:crate_and_barrel/models/product_variant.dart';
import 'package:crate_and_barrel/widgets/color_button.dart';
import 'package:crate_and_barrel/widgets/quantity_control_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late List<ProductVariant> variants;
  late ProductVariant selectedVariant;
  late AnimationController _quantitySelectorController;

  final duration = const Duration(milliseconds: 500);
  final Tween<Offset> _slideTween =
      Tween(begin: const Offset(0, 1), end: const Offset(0, 0));

  @override
  void initState() {
    super.initState();
    variants = [
      ProductVariant(image: kLampImagePath, color: const Color(0xff2D4046)),
      ProductVariant(image: kLampImagePath, color: const Color(0xffDF9E4D)),
      ProductVariant(image: kLampImagePath, color: const Color(0xff444158)),
      ProductVariant(image: kLampImagePath, color: const Color(0xffC1C1C1)),
    ];
    selectedVariant = variants[0];

    _quantitySelectorController =
        AnimationController(vsync: this, duration: duration);
  }

  @override
  void dispose() {
    super.dispose();
    _quantitySelectorController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.chevron_left,
            size: 35,
          ),
          onPressed: () {},
        ),
        title: const Text('Crate&Barrel'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: kDefaultPadding),
            child: IconButton(
              icon: SvgPicture.asset(kCartIconPath),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImageDisplay(context),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: kDefaultPadding,
                  ),
                  child: _buildProductDetailsDisplay(),
                )
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomBar(),
          ),
          _buildQuantitySelector()
        ],
      ),
    );
  }

  Widget _buildImageDisplay(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: duration,
            height: 380,
            decoration: BoxDecoration(
              borderRadius:
                  const BorderRadius.only(bottomRight: Radius.circular(100)),
              color: selectedVariant.color,
            ),
            width: 250,
          ),
          Positioned(
              top: 155, left: -50, child: Image.asset(kLampLightImagePath)),
          Image.asset(kLampImagePath),
        ],
      ),
    );
  }

  Widget _buildProductDetailsDisplay() {
    const spacer = SizedBox(
      height: 15,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('SKU: 311337'),
        spacer,
        const Text('Maddox Dome Pendant Large with Black Socket',
            style: TextStyle(
                fontSize: 24, fontWeight: FontWeight.bold, height: 1.5)),
        spacer,
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildColorsDisplay(),
            const Text('\$179.00',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                )),
          ],
        ),
        spacer,
        RichText(
          text: const TextSpan(text: 'Free Delivery', children: [
            TextSpan(
                text: ' Friday',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ))
          ]),
        ),
        const SizedBox(height: 5),
        const Text('Delivery to Akram - Dallas 75204'),
        spacer,
        const Text(
          'Details',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
        ),
        spacer,
        const Text(
          'Our Maddox collection mixes and matches finishes and features,'
          ' creating the perfect combination for your home. Steel shades in'
          ' a variety of shapes, sizes and modern hues pair matte exteriors '
          'and glossy white interiors that reflect light beautifully, accented'
          ' by decorative socket caps and ceiling plates in a range of finishes.'
          ' Strikingly simple with clean geometry, this large dome pendant light '
          'contrasts a softly rounded matte mustard yellow shade with its bright'
          ' inner surface. Hang the adjustable-height pendant over a kitchen island,'
          ' reading nook or dining table for a bold, graphic look and useful',
          textAlign: TextAlign.left,
          style:
              TextStyle(fontWeight: FontWeight.w300, fontSize: 13, height: 1.5),
        ),
      ],
    );
  }

  _buildColorsDisplay() {
    return Row(
      children: [
        for (ProductVariant variant in variants)
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: ColorButton(
              productColor: variant.color,
              isSelected: selectedVariant.color == variant.color,
              onPressed: () {
                setState(() {
                  selectedVariant = variant;
                });
              },
            ),
          )
      ],
    );
  }

  Widget _buildBottomBar() {
    return Stack(
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  kPrimaryColor.withOpacity(0.8),
                  kPrimaryColor,
                ],
                stops: const [
                  0.0,
                  0.4
                ]),
          ),
        ),
        _buildControlButtons()
      ],
    );
  }

  Widget _buildControlButtons() {
    return Padding(
      padding:
          const EdgeInsets.symmetric(horizontal: kDefaultPadding, vertical: 10),
      child: Row(
        children: [
          InkWell(
            child: Material(
              color: Colors.transparent,
              child: Row(mainAxisSize: MainAxisSize.min, children: const [
                Text(
                  'Qty: 1',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(width: 5),
                Icon(
                  Icons.expand_more,
                  color: Colors.white,
                  size: 30,
                )
              ]),
            ),
            onTap: () {
              if (_quantitySelectorController.isDismissed) {
                _quantitySelectorController.forward();
              } else if (_quantitySelectorController.isCompleted) {
                _quantitySelectorController.reverse();
              }
            },
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: SvgPicture.asset(
              kFavoriteconPath,
              width: 30,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          SizedBox(
            width: 70,
            height: 70,
            child: FloatingActionButton(
                elevation: 0,
                backgroundColor: Colors.white,
                child: SvgPicture.asset(
                  kAddToCartIconPath,
                  width: 25,
                ),
                onPressed: () {}),
          )
        ],
      ),
    );
  }

  _buildQuantitySelector() {
    const spacer = SizedBox(
      height: 25,
    );
    return SlideTransition(
      position: _slideTween.animate(_quantitySelectorController),
      child: DraggableScrollableSheet(
          expand: true,
          initialChildSize: 0.36,
          maxChildSize: 0.36,
          builder: (context, _) {
            return Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(35))),
              padding: const EdgeInsets.all(30),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Quantity',
                      style: TextStyle(
                        fontSize: 20,
                        color: kTextDarkColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: Column(children: [
                        spacer,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            QuantityControlButton(
                                isIncrement: false, onPressed: () {}),
                            const Text('2',
                                style: TextStyle(
                                  color: kTextDarkColor,
                                  fontSize: 28,
                                  fontWeight: FontWeight.w500,
                                )),
                            QuantityControlButton(
                                isIncrement: false, onPressed: () {}),
                          ],
                        ),
                        spacer,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () {
                                  _quantitySelectorController.reverse();
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () {},
                                child: const Text(
                                  'Done',
                                  style: TextStyle(
                                    color: Color(0xff4187ff),
                                  ),
                                ))
                          ],
                        )
                      ]),
                    )
                  ]),
            );
          }),
    );
  }
}
