import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:flutter_universe/constants.dart';
import 'package:flutter_universe/data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:rive/rive.dart' as rive;

GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

class ChuckNorrisScreen extends StatefulWidget {
  @override
  _ChuckNorrisScreenState createState() => _ChuckNorrisScreenState();
}

class _ChuckNorrisScreenState extends State<ChuckNorrisScreen>
    with TickerProviderStateMixin, SingleTickerProviderStateMixin {
  //card data
  String icon_url = '';
  String joke = '';
  bool isRightSwipe = true;

  //card data ends

  int cardsnum = 3;
  bool _isAnimation1 = true;

  void _togglePlay() {
    // setState(() => _controller.isActive = !_controller.isActive);

    if (_isAnimation1) {
      setState(() {
        _riveArtboard
            .addController(_controller = rive.SimpleAnimation('Animation1'));
      });
    } else {
      setState(() {
        _riveArtboard
            .addController(_controller = rive.SimpleAnimation('Animation2'));
      });
    }
    _isAnimation1 = !_isAnimation1;
  }

  /// Tracks if the animation is playing by whether controller is running.

  rive.Artboard _riveArtboard;
  rive.RiveAnimationController _controller;

  @override
  void initState() {
    super.initState();
    rootBundle.load('assets/marty_v6.riv').then((data) async {
      final file = rive.RiveFile();

      // Load the RiveFile from the binary data.
      if (file.import(data)) {
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        // Add a controller to play back a known animation on the main/default
        // artboard. We store a reference to it so we can toggle playback.= rive.SimpleAnimation('Animation1')
        artboard
            .addController(_controller = rive.SimpleAnimation('Animation2'));
        setState(() => _riveArtboard = artboard);
      }
    });
    getData;
  }

  void get getData async {
    const url = 'https://api.chucknorris.io/jokes/random';
    try {
      http.Response myData = await http.get(url);
      var realData = json.decode(myData.body);

      setState(() {
        icon_url = realData['icon_url'];
        joke = realData['value'];
      });

      print(realData['value']);
      _togglePlay();
    } catch (e) {
      print(e.toString());
    }
  }

  swipeCompleteCallback() {
    SnackBar snackBar = SnackBar(
      content: Text(
        'Saved in your gallery!!!',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      duration: Duration(milliseconds: 300),
      backgroundColor: isRightSwipe ? Colors.greenAccent : Colors.black54,
    );
    scaffoldkey.currentState.showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
      key: scaffoldkey,
      backgroundColor: gradientEndColor,
      body: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [gradientStartColor, gradientEndColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.3, 0.7])),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset(
                '${apis[0].iconImage}',
                height: 300,
                width: 300,
              ),
              SizedBox(
                height: 300,
                child: TinderSwapCard(
                  swipeUp: true,
                  swipeDown: true,
                  orientation: AmassOrientation.BOTTOM,
                  totalNum: 3,
                  stackNum: cardsnum,
                  swipeEdge: 5.0,
                  maxWidth: MediaQuery.of(context).size.width * 0.9,
                  maxHeight: MediaQuery.of(context).size.width * 0.9,
                  minWidth: MediaQuery.of(context).size.width * 0.8,
                  minHeight: MediaQuery.of(context).size.width * 0.8,
                  cardBuilder: (context, index) => Stack(
                    alignment: Alignment.center,
                    children: [
                      Card(
                        child: Opacity(
                          opacity: 0.2,
                          child: Container(
                            padding: const EdgeInsets.all(50),
                            child: Image.asset('${apis[0].iconImage}'),
                          ),
                        ),
                      ),
                      if (icon_url != '')
                        Positioned(
                          left: mediaQuery.width / 3 + 10,
                          top: 5,
                          child: Image.network(
                            icon_url,
                            height: 50,
                            width: 50,
                            alignment: Alignment.topCenter,
                          ),
                        ),
                      if (joke != '')
                        Positioned(
                          bottom: 80,
                          child: Container(
                            margin: const EdgeInsets.only(top: 50),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 5),
                            width: 300,
                            child: Text(
                              joke.toString(),
                              style: GoogleFonts.acme(
                                  color: Colors.black.withOpacity(0.8),
                                  wordSpacing: 1.2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textScaleFactor * 20),
                              // style: TextStyle(
                              //     fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                    ],
                  ),
                  cardController: CardController(),
                  allowVerticalMovement: false,
                  swipeUpdateCallback:
                      (DragUpdateDetails details, Alignment align) {
                    /// Get swiping card's alignment

                    if (align.x < 0) {
                      isRightSwipe = false;
                      //Card is LEFT swiping
                    } else if (align.x > 0) {
                      isRightSwipe = true;
                      //Card is RIGHT swiping
                    }
                  },
                  swipeCompleteCallback:
                      (CardSwipeOrientation orientation, int index) {
                    setState(() {
                      cardsnum++;
                      print(cardsnum);
                    });

                    getData;
                    swipeCompleteCallback();

                    /// Get orientation & index of swiped card!
                  },
                ),
              ),
              Spacer(),
              _riveArtboard == null
                  ? const SizedBox()
                  : Container(
                      height: 100,
                      width: 100,
                      child: rive.Rive(artboard: _riveArtboard)),
            ],
          ),
        ),
      ),
    );
  }
}
// Container(
// decoration: BoxDecoration(
// gradient: LinearGradient(
// colors: [gradientStartColor, gradientEndColor],
// begin: Alignment.topCenter,
// end: Alignment.bottomCenter,
// stops: [0.3, 0.7])),
// child: SafeArea(
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// Padding(
// padding: const EdgeInsets.all(32.0),
// child: Column(
// children: <Widget>[
// Text(
// 'Chunk NoRrIs',
// style: TextStyle(
// fontFamily: 'Avenir',
// fontSize: 44,
// color: const Color(0xffffffff),
// fontWeight: FontWeight.w900,
// ),
// textAlign: TextAlign.left,
// ),
// SizedBox(height: 10)
// ],
// ),
// ),
// Container(
// height: 430,
// padding: const EdgeInsets.only(left: 20),
// child: Swiper(
// itemCount: 1,
// itemWidth: MediaQuery.of(context).size.width - 2 * 64,
// layout: SwiperLayout.STACK,
// // pagination: SwiperPagination(
// //   builder:
// //       DotSwiperPaginationBuilder(activeSize: 20, space: 8),
// // ),
// itemBuilder: (context, index) {
// return Stack(
// children: <Widget>[
// Column(
// children: <Widget>[
// SizedBox(height: 100),
// Card(
// elevation: 8,
// shape: RoundedRectangleBorder(
// borderRadius: BorderRadius.circular(32),
// ),
// color: Colors.white,
// child: Padding(
// padding: const EdgeInsets.all(32.0),
// child: Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: <Widget>[
// SizedBox(height: 60),
// Text(
// 'll',
// style: TextStyle(
// fontFamily: 'Avenir',
// fontSize: 35,
// color: const Color(0xff47455f),
// fontWeight: FontWeight.w900,
// ),
// textAlign: TextAlign.left,
// ),
// Text(
// 'ujh',
// style: TextStyle(
// fontFamily: 'Avenir',
// fontSize: 14,
// color: primaryTextColor,
// fontWeight: FontWeight.w500,
// ),
// textAlign: TextAlign.left,
// ),
// SizedBox(height: 22),
// Row(
// children: <Widget>[
// Text(
// 'Know more',
// style: TextStyle(
// fontFamily: 'Avenir',
// fontSize: 18,
// color: secondaryTextColor,
// fontWeight: FontWeight.w500,
// ),
// textAlign: TextAlign.left,
// ),
// Icon(
// Icons.arrow_forward,
// color: secondaryTextColor,
// ),
// ],
// ),
// ],
// ),
// ),
// ),
// ],
// ),
// // Image.asset(apis[index].iconImage),
// Positioned(
// right: 24,
// bottom: 60,
// child: Text(
// '😎',
// style: TextStyle(
// fontFamily: 'Avenir',
// fontSize: 200,
// color: primaryTextColor.withOpacity(0.08),
// fontWeight: FontWeight.w900,
// ),
// textAlign: TextAlign.left,
// ),
// ),
// ],
// );
// },
// ),
// ),
// ],
// ),
// ),
// ),