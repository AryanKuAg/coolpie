import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_universe/constants.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive/rive.dart' as rive;
import 'package:http/http.dart' as http;

class TronalddumpScreen extends StatefulWidget {
  @override
  _TronalddumpScreenState createState() => _TronalddumpScreenState();
}

class _TronalddumpScreenState extends State<TronalddumpScreen>
    with TickerProviderStateMixin {
  rive.Artboard _riveArtboard;
  rive.RiveAnimationController _controller;
  ConfettiController _controllerTopCenter;
  String dataString = 'CLICK HERE!!!';

  @override
  void initState() {
    super.initState();
    _controllerTopCenter =
        ConfettiController(duration: const Duration(seconds: 5));
    rootBundle.load('assets/deerdance.riv').then((data) async {
      final file = rive.RiveFile();

      // Load the RiveFile from the binary data.
      if (file.import(data)) {
        // The artboard is the root of the animation and gets drawn in the
        // Rive widget.
        final artboard = file.mainArtboard;
        // Add a controller to play back a known animation on the main/default
        // artboard. We store a reference to it so we can toggle playback.= rive.SimpleAnimation('Animation1')
        artboard.addController(_controller = rive.SimpleAnimation('dance'));
        setState(() => _riveArtboard = artboard);
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _controllerTopCenter.dispose();
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  void get getData async {
    const url = 'https://www.tronalddump.io/random/quote';
    try {
      http.Response myData = await http.get(url, headers: {
        "accept": "application/hal+json",
        "x-rapidapi-key": "SIGN-UP-FOR-KEY",
        "x-rapidapi-host": "matchilling-tronald-dump-v1.p.rapidapi.com",
        "useQueryString": 'true'
      });

      var realData = json.decode(myData.body);
      print(realData['value']);

      setState(() {
        dataString = realData['value'].toString().trim().replaceAll('.', '');
        // icon_url = realData['icon_url'];
        // joke = realData['value'];
      });
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
          mainAxisAlignment: MainAxisAlignment.start,
          // crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: ConfettiWidget(
                confettiController: _controllerTopCenter,
                blastDirection: pi / 2,
                maxBlastForce: 5, // set a lower max blast force
                minBlastForce: 2, // set a lower min blast force
                emissionFrequency: 0.05,
                numberOfParticles: 50, // a lot of particles at once
                gravity: 1,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            GestureDetector(
              onTap: () {
                _controllerTopCenter.play();

                getData;
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Text(
                  dataString,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.ubuntu(
                      fontSize: textScaleFactor * 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            Spacer(),
            _riveArtboard == null
                ? const SizedBox()
                : Container(
                    height: 300,
                    width: 300,
                    child: rive.Rive(artboard: _riveArtboard)),
          ],
        ),
      ),
    ));
  }
}
