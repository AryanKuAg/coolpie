import 'dart:convert';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_universe/constants.dart';
import 'package:flutter_universe/specificApiScreen/advice/adviceScreen.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart' as rive;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NumbersScreen extends StatefulWidget {
  @override
  _NumbersScreenState createState() => _NumbersScreenState();
}

class _NumbersScreenState extends State<NumbersScreen>
    with TickerProviderStateMixin {
  bool _isAnimation1 = false;
  AdmobInterstitial interstitialAd;
  TextEditingController _textEditingController = TextEditingController();
  String _value = 'Search, My Dear!!!';

  void _togglePlay() {
    if (_isAnimation1) {
      setState(() {
        _riveArtboard
            .addController(_controller = rive.SimpleAnimation('Animation 1'));
      });
    } else {
      setState(() {
        _riveArtboard
            .addController(_controller = rive.SimpleAnimation('Animation 2'));
      });
    }
    _isAnimation1 = !_isAnimation1;
  }

  void _rocketPlay() {
    setState(() {
      _rocketriveArtboard.addController(
          _rocketcontroller = rive.SimpleAnimation('Animation 2'));
    });
  }

  /// Tracks if the animation is playing by whether controller is running.

  rive.Artboard _riveArtboard;
  rive.RiveAnimationController _controller;

  rive.Artboard _rocketriveArtboard;
  rive.RiveAnimationController _rocketcontroller;

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
    rootBundle.load('assets/searchanimation.riv').then((data) async {
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
    rootBundle.load('assets/rocketlaunch.riv').then((data) async {
      final file = rive.RiveFile();

      // Load the RiveFile from the binary data.
      if (file.import(data)) {
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        // Add a controller to play back a known animation on the main/default
        // artboard. We store a reference to it so we can toggle playback.= rive.SimpleAnimation('Animation1')
        artboard.addController(
            _rocketcontroller = rive.SimpleAnimation('Animation 1'));
        setState(() => _rocketriveArtboard = artboard);
      }
    });
  }

  fetchApiData({int myNum, String type}) async {
    final String url = 'http://numbersapi.com/$myNum/$type';
    try {
      http.Response myData = await http.get(url);
      String _body = myData.body.toString();
      print(_body);
      setState(() {
        _value = _body;
      });
    } catch (e) {
      print(e.toString());
    }
    // var realData = json.decode(_body);
    // print(realData);
    // } catch (e) {
    //   print(e.toString());
    //   print('error');
    // }
  }

  @override
  void dispose() {
    super.dispose();
    interstitialAd.dispose();
  }

  String dropdownValue = 'Trivia';
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context).size;
    final textScaleFactor = MediaQuery.of(context).textScaleFactor;
    final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [gradientStartColor, gradientEndColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.3, 0.7])),
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 50,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.circular(20),
                      color: gradientEndColor),
                  child: TextField(
                    controller: _textEditingController,
                    onEditingComplete: () {
                      int myInt =
                          double.parse(_textEditingController.text).toInt();

                      if (myInt <= 1500) {
                        fetchApiData(
                            myNum: myInt, type: dropdownValue.toLowerCase());
                        _rocketPlay();
                      } else {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title:
                                Text('Number Should be less than 1500 😎!!!'),
                            actions: [
                              FlatButton(
                                child: Text('Ok'),
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                              )
                            ],
                          ),
                        );
                      }
                    },
                    showCursor: false,
                    keyboardType: TextInputType.number,
                    onTap: _togglePlay,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: InputDecoration(
                        prefixIcon: _riveArtboard == null
                            ? const SizedBox()
                            : Container(
                                height: 5,
                                width: 5,
                                child: rive.Rive(artboard: _riveArtboard)),
                        border: InputBorder.none),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      color: gradientStartColor,
                      borderRadius: BorderRadius.circular(20)),
                  margin: const EdgeInsets.only(left: 280),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    elevation: 160,
                    style: TextStyle(color: Colors.pinkAccent),
                    underline: Container(
                      height: 1,
                      color: gradientStartColor,
                    ),
                    onChanged: (String newValue) {
                      print(newValue);
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>['Trivia', 'Year', 'Math']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      _value,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.permanentMarker(
                          fontSize: textScaleFactor * 25, color: Colors.white),
                    ),
                  ),
                ),
                Spacer(),
                _rocketriveArtboard == null
                    ? const SizedBox()
                    : Padding(
                        padding: EdgeInsets.only(bottom: keyboardHeight),
                        child: Container(
                          height: 150,
                          width: mediaQuery.width,
                          child: rive.Rive(artboard: _rocketriveArtboard),
                        ),
                      )
              ],
            ),
          )),
    );
  }
}
