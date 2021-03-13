import 'dart:convert';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_tindercard/flutter_tindercard.dart';
import 'package:flutter_universe/constants.dart';
import 'package:flutter_universe/data.dart';
import 'package:flutter_universe/specificApiScreen/advice/adviceScreen.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:rive/rive.dart' as rive;

GlobalKey<ScaffoldState> scaffoldkey = GlobalKey<ScaffoldState>();

class ChuckNorrisScreen extends StatefulWidget {
  @override
  _ChuckNorrisScreenState createState() => _ChuckNorrisScreenState();
}

class _ChuckNorrisScreenState extends State<ChuckNorrisScreen>
    with TickerProviderStateMixin, SingleTickerProviderStateMixin {
  AdmobInterstitial interstitialAd;
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
    interstitialAd = AdmobInterstitial(
      adUnitId: getInterstitialAdUnitId(),
      listener: (AdmobAdEvent event, Map<String, dynamic> args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
      },
    );
    interstitialAd.load();

    Future.delayed(Duration(seconds: 3), () {
      interstitialAd.show();
    });
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

  @override
  void dispose() {
    super.dispose();
    interstitialAd.dispose();
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
    // LocalSavedValue localSavedValue =
    //     LocalSavedValue(image: icon_url, value: joke);
    // LocalDatabase localDatabase = LocalDatabase();

    if (joke != '') {
      // localDatabase.saveLocalSavedValue(localSavedValue);

      SnackBar snackBar = SnackBar(
        content: Text(
          isRightSwipe ? 'Saved in your gallery!!!' : 'Not Saved!!!',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        duration: Duration(milliseconds: 300),
        backgroundColor: isRightSwipe ? Colors.greenAccent : Colors.black54,
      );
      scaffoldkey.currentState.showSnackBar(snackBar);
    }
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
                          child: CachedNetworkImage(
                            imageUrl: icon_url,
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
                                  color: Colors.black.withOpacity(0.7),
                                  wordSpacing: 1.2,
                                  fontWeight: FontWeight.bold,
                                  fontSize: textScaleFactor * 20),
                              // style: TextStyle(
                              //     fontSize: 20, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        )
                      else
                        Lottie.asset('assets/nodata.json'),
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
                    // swipeCompleteCallback();

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
