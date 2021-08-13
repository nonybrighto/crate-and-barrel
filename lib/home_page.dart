import 'package:crate_and_barrel/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

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
          )
        ],
      ),
    );
  }

  Widget _buildImageDisplay(BuildContext context) {
    return SizedBox(
      height: 420,
      child: Stack(
        children: [
          Container(
            height: 380,
            decoration: const BoxDecoration(
                borderRadius:
                    BorderRadius.only(bottomRight: Radius.circular(100)),
                color: Color(0xff2d4046)),
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
    return Text('Colors');
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
            onTap: () {},
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
}