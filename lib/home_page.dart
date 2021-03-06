import 'package:crate_and_barrel/constants.dart';
import 'package:crate_and_barrel/models/product_variant.dart';
import 'package:crate_and_barrel/widgets/cart_add_display.dart';
import 'package:crate_and_barrel/widgets/cart_icon.dart';
import 'package:crate_and_barrel/widgets/variant_button.dart';
import 'package:crate_and_barrel/widgets/quantity_control_button.dart';
import 'package:crate_and_barrel/widgets/variant_slider.dart';
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

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late List<ProductVariant> variants;
  late ProductVariant selectedVariant;
  late AnimationController _quantitySelectorController;
  late AnimationController _controlButtonsController;
  late AnimationController _quantityCounterController;
  late AnimationController _cartAddController;
  late AnimationController _slideController;
  late Offset cartIconPosition;
  late Color notificationColor;
  Offset selectedVariantButtonPosition = const Offset(50, 300);
  bool itemAddedToCart = false;
  int cartContentCount = 0;
  int quantityToAdd = 1;

  final _cartIconKey = GlobalKey();
  final _firstVariantButtonKey = GlobalKey();

  final duration = const Duration(milliseconds: 300);
  final Tween<Offset> _slideTween =
      Tween(begin: const Offset(0, 0.5), end: const Offset(0, 0));

  @override
  void initState() {
    super.initState();
    variants = [
      ProductVariant(
        name: 'green',
        image: kLampImagePath,
        color: const Color(0xff2D4046),
        backgroundColor: const Color(0xff2D4046),
      ),
      ProductVariant(
        name: 'yellow',
        image: '$kImagesPath/yellow_lamp.png',
        color: const Color(0xffDF9E4D),
        backgroundColor: const Color(0xffA96301),
      ),
      ProductVariant(
        name: 'purple',
        image: '$kImagesPath/purple_lamp.png',
        color: const Color(0xff444158),
        backgroundColor: const Color(0xff444158),
      ),
      ProductVariant(
        name: 'grey',
        image: '$kImagesPath/grey_lamp.png',
        color: const Color(0xffC1C1C1),
        backgroundColor: const Color(0xff8d8d8d),
      ),
    ];
    selectedVariant = variants[0];
    notificationColor = selectedVariant.color;

    _quantitySelectorController =
        AnimationController(vsync: this, duration: duration);
    _controlButtonsController =
        AnimationController(vsync: this, duration: duration);
    _quantityCounterController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 200))
      ..forward();
    _cartAddController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: kCartAddDurationInMs));

    double maximumScrollAngle = kSliderRotationAngle * (variants.length - 1);
    _slideController = AnimationController(
        lowerBound: 0.0,
        upperBound: maximumScrollAngle,
        vsync: this,
        duration: const Duration(milliseconds: 500));

    _controlButtonsController.forward();
    _getCartIconPosition();
    _getDefaultVariantButtonPosition();
  }

  @override
  void dispose() {
    super.dispose();
    _quantitySelectorController.dispose();
    _controlButtonsController.dispose();
    _cartAddController.dispose();
    _slideController.dispose();
    _quantityCounterController.dispose();
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
            child: CartIcon(
              key: _cartIconKey,
              notificationColor: notificationColor,
              hasNotification: itemAddedToCart,
              contentCount: cartContentCount,
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
                VariantSlider(
                  slideController: _slideController,
                  productVariants: variants,
                  selectedVariant: selectedVariant,
                  onVariantSelected: (variant) {
                    setState(() {
                      selectedVariant = variant;
                    });
                  },
                ),
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
            _buildVariantButtonsDisplay(),
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

  _buildVariantButtonsDisplay() {
    return Row(
      children: [
        for (int i = 0; i < variants.length; i++)
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: VariantButton(
              key: i == 0 ? _firstVariantButtonKey : null,
              variantColor: variants[i].color,
              isSelected: selectedVariant.color == variants[i].color,
              onPressed: (offset) {
                setState(() {
                  selectedVariant = variants[i];
                  selectedVariantButtonPosition =
                      offset; // This determines the starting point of the expanding dot on the overlay
                  _slideController.animateTo(i * kSliderRotationAngle);
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
    return SlideTransition(
      position: _slideTween.animate(_controlButtonsController),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: kDefaultPadding, vertical: 10),
        child: Row(
          children: [
            InkWell(
              child: Material(
                color: Colors.transparent,
                child: Row(mainAxisSize: MainAxisSize.min, children: [
                  Text(
                    'Qty: $quantityToAdd',
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 5),
                  const Icon(
                    Icons.expand_more,
                    color: Colors.white,
                    size: 30,
                  )
                ]),
              ),
              onTap: () async {
                if (_quantitySelectorController.isDismissed) {
                  await _controlButtonsController.reverse();
                  _quantitySelectorController.forward();
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
                  onPressed: () async {
                    OverlayEntry entry = OverlayEntry(builder: (context) {
                      return CartAddDisplay(
                          itemCount: quantityToAdd,
                          selectedVariant: selectedVariant,
                          cartIconPosition: cartIconPosition,
                          colorButtonPosition: selectedVariantButtonPosition,
                          animationController: _cartAddController);
                    });
                    Overlay.of(context)!.insert(entry);
                    await _cartAddController.forward(from: 0);
                    entry.remove();
                    setState(() {
                      itemAddedToCart = true;
                      notificationColor = selectedVariant.color;
                      cartContentCount += quantityToAdd;
                      quantityToAdd = 1;
                    });
                  }),
            )
          ],
        ),
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
                                isIncrement: false,
                                onPressed: () {
                                  setState(() {
                                    quantityToAdd = quantityToAdd == 0
                                        ? 0
                                        : ++quantityToAdd;
                                  });
                                  _quantityCounterController.forward(from: 0);
                                }),
                            AnimatedBuilder(
                                animation: _quantityCounterController,
                                child: Text('$quantityToAdd',
                                    style: const TextStyle(
                                      color: kTextDarkColor,
                                      fontSize: 28,
                                      fontWeight: FontWeight.w500,
                                    )),
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _quantityCounterController.value,
                                    child: child,
                                  );
                                }),
                            QuantityControlButton(
                                isIncrement: true,
                                onPressed: () {
                                  _quantityCounterController.forward(from: 0);
                                  setState(() {
                                    quantityToAdd += 1;
                                  });
                                }),
                          ],
                        ),
                        spacer,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                                onPressed: () async {
                                  await _quantitySelectorController.reverse();
                                  await _controlButtonsController.forward();
                                },
                                child: const Text('Cancel')),
                            TextButton(
                                onPressed: () async {
                                  await _quantitySelectorController.reverse();
                                  await _controlButtonsController.forward();
                                },
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

  _getCartIconPosition() {
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        RenderBox object =
            _cartIconKey.currentContext!.findRenderObject() as RenderBox;
        Offset globalPosition = object.localToGlobal(Offset.zero);
        cartIconPosition = globalPosition;
      });
    }
  }

  Widget? _getDefaultVariantButtonPosition() {
    if (WidgetsBinding.instance != null) {
      WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
        RenderBox object = _firstVariantButtonKey.currentContext!
            .findRenderObject() as RenderBox;
        Offset globalPosition = object.localToGlobal(Offset.zero);
        selectedVariantButtonPosition = globalPosition;
      });
    }
  }
}
