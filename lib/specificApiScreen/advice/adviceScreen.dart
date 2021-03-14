import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_universe/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart' as rive;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AdviceScreen extends StatefulWidget {
  @override
  _AdviceScreenState createState() => _AdviceScreenState();
}

class _AdviceScreenState extends State<AdviceScreen>
    with TickerProviderStateMixin {
  AdmobInterstitial interstitialAd;
  String value = 'Hit that monk with the stone';
  void _togglePlay() {
    setState(() {
      _riveArtboard
          .addController(_controller = rive.SimpleAnimation('Animation 2'));
      getData;
    });
    Future.delayed(Duration(seconds: 10), () {
      setState(() {
        _riveArtboard
            .addController(_controller = rive.SimpleAnimation('Animation 1'));
        print('hey yo');
      });
    });
  }

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

    Future.delayed(Duration(seconds: 3), () async {
      Future<SharedPreferences> sharedPreferences =
          SharedPreferences.getInstance();
      SharedPreferences sp = await sharedPreferences;
      var code = sp.get('code');
      if (code != null && code == 'alemantrix') {
        print('Ads is Disabled!!!');
      } else {
        interstitialAd.show();
      }
    });
    // triggerInterstitialAd();
    rootBundle.load('assets/monk.riv').then((data) async {
      final file = rive.RiveFile();

      // Load the RiveFile from the binary data.
      if (file.import(data)) {
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        // Add a controller to play back a known animation on the main/default
        // artboard. We store a reference to it so we can toggle playback.= rive.SimpleAnimation('Animation1')
        artboard
            .addController(_controller = rive.SimpleAnimation('Animation 1'));
        setState(() => _riveArtboard = artboard);
      }
    });
  }

  // triggerInterstitialAd() async {
  //   bool isLoaded = await interstitialAd.isLoaded;
  //
  //   if (isLoaded) {
  //     interstitialAd.show();
  //   } else {
  //     print('ads load nahi hua');
  //   }
  // }

  @override
  void dispose() {
    super.dispose();
    interstitialAd.dispose();
  }

  void get getData async {
    const url = 'https://api.adviceslip.com/advice';
    try {
      http.Response myData = await http.get(url);
      var realData = json.decode(myData.body);

      setState(() {
        value = realData['slip']['advice'];
      });
      print(realData);
      print(realData['slip']['advice']);
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    return Scaffold(
        body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [gradientStartColor, gradientEndColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 0.7])),
            child: SafeArea(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      value,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.ubuntu(
                          fontSize: textScaleFactor * 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  _riveArtboard == null
                      ? const SizedBox()
                      : DragTarget<int>(
                          builder: (
                            BuildContext context,
                            List<dynamic> accepted,
                            List<dynamic> rejected,
                          ) {
                            return Container(
                                height: 400,
                                width: 400,
                                child: rive.Rive(artboard: _riveArtboard));
                          },
                          onAccept: (_) {
                            print('kaam ho gaya');
                            _togglePlay();
                          },
                        ),
                  Spacer(),
                  Draggable<int>(
                    child: Image.asset(
                      'assets/rock.png',
                      height: 100,
                      width: 200,
                    ),
                    data: 10,
                    feedback: Image.asset(
                      'assets/rock.png',
                      height: 50,
                      width: 50,
                    ),
                    childWhenDragging: Image.asset(
                      'assets/rock.png',
                      height: 100,
                      width: 200,
                    ),
                  )
                ],
              ),
            )));
  }
}

String getInterstitialAdUnitId() {
  if (Platform.isIOS) {
    return 'ca-app-pub-3940256099942544/4411468910';
  } else if (Platform.isAndroid) {
    return 'ca-app-pub-3940256099942544/1033173712';
  }
  return null;
}
