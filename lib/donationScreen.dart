import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter_universe/constants.dart';
import 'package:flutter_universe/home_page.dart';
import 'package:flutter_universe/secretPage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shake/shake.dart';
import 'paymentScreen/googlePayScreen.dart';
import 'paymentScreen/paypalScreen.dart';
import 'paymentScreen/paytmScreen.dart';
import 'paymentScreen/phonepeScreen.dart';

class DonationScreen extends StatefulWidget {
  @override
  _DonationScreenState createState() => _DonationScreenState();
}

class _DonationScreenState extends State<DonationScreen> {
  ShakeDetector detector;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    detector = ShakeDetector.autoStart(onPhoneShake: () {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SecretPage()));
    });
  }

  @override
  void dispose() {
    super.dispose();
    detector.stopListening();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gradientEndColor,
      body: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [gradientStartColor, gradientEndColor],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  stops: [0.3, 0.7])),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/patreon.png',
                    width: 200,
                    height: 100,
                  ),
                  Text(
                    'www.patreon.com/alemantrix',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.roboto(
                      color: Color.fromRGBO(237, 255, 236, 1),
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromRGBO(246, 223, 235, 0.1)),
                    child: Text(
                      "IT'S AN AMAZING LIFE AND I CAN'T ENJOY IT",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.redressed(
                        wordSpacing: 1.3,
                        color: Color.fromRGBO(237, 255, 236, 1),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                  // SizedBox(height: 20),
                  // Text(
                  //   'Donation',
                  //   style: TextStyle(
                  //     fontFamily: 'Avenir',
                  //     fontSize: 44,
                  //     color: const Color(0xffffffff),
                  //     fontWeight: FontWeight.w900,
                  //   ),
                  //   textAlign: TextAlign.left,
                  // ),
                  // SizedBox(height: 50),
                  // Container(
                  //   height: 430,
                  //   padding: const EdgeInsets.only(left: 20),
                  //   child: Swiper(
                  //     itemCount: myPayments.length,
                  //     itemWidth: MediaQuery.of(context).size.width - 2 * 64,
                  //     layout: SwiperLayout.STACK,
                  //     pagination: SwiperPagination(
                  //       builder:
                  //           DotSwiperPaginationBuilder(activeSize: 20, space: 8),
                  //     ),
                  //     itemBuilder: (context, index) {
                  //       return InkWell(
                  //         onTap: () {
                  //           Navigator.push(
                  //             context,
                  //             PageRouteBuilder(
                  //               pageBuilder: (context, a, b) =>
                  //                   myPayments[index].screen,
                  //             ),
                  //           );
                  //         },
                  //         child: Stack(
                  //           children: <Widget>[
                  //             Column(
                  //               children: <Widget>[
                  //                 SizedBox(height: 100),
                  //                 Card(
                  //                   elevation: 8,
                  //                   shape: RoundedRectangleBorder(
                  //                     borderRadius: BorderRadius.circular(32),
                  //                   ),
                  //                   color: Colors.white,
                  //                   child: Padding(
                  //                     padding: const EdgeInsets.all(32.0),
                  //                     child: Column(
                  //                       crossAxisAlignment:
                  //                           CrossAxisAlignment.start,
                  //                       children: <Widget>[
                  //                         SizedBox(height: 60),
                  //                         Text(
                  //                           myPayments[index].name,
                  //                           style: TextStyle(
                  //                             fontFamily: 'Avenir',
                  //                             fontSize: 35,
                  //                             color: const Color(0xff47455f),
                  //                             fontWeight: FontWeight.w900,
                  //                           ),
                  //                           textAlign: TextAlign.left,
                  //                         ),
                  //                         Text(
                  //                           myPayments[index].description,
                  //                           style: TextStyle(
                  //                             fontFamily: 'Avenir',
                  //                             fontSize: 14,
                  //                             color: primaryTextColor,
                  //                             fontWeight: FontWeight.w500,
                  //                           ),
                  //                           textAlign: TextAlign.left,
                  //                         ),
                  //                         SizedBox(height: 22),
                  //                         Row(
                  //                           children: <Widget>[
                  //                             Text(
                  //                               'Know more',
                  //                               style: TextStyle(
                  //                                 fontFamily: 'Avenir',
                  //                                 fontSize: 18,
                  //                                 color: secondaryTextColor,
                  //                                 fontWeight: FontWeight.w500,
                  //                               ),
                  //                               textAlign: TextAlign.left,
                  //                             ),
                  //                             Icon(
                  //                               Icons.arrow_forward,
                  //                               color: secondaryTextColor,
                  //                             ),
                  //                           ],
                  //                         ),
                  //                       ],
                  //                     ),
                  //                   ),
                  //                 ),
                  //               ],
                  //             ),
                  //             Image.asset(
                  //               myPayments[index].image,
                  //               height: 200,
                  //               width: 200,
                  //             ),
                  //             Positioned(
                  //               right: 24,
                  //               bottom: 60,
                  //               child: Text(
                  //                 myPayments[index].description.toString(),
                  //                 style: TextStyle(
                  //                   fontFamily: 'Avenir',
                  //                   fontSize: 200,
                  //                   color: primaryTextColor.withOpacity(0.08),
                  //                   fontWeight: FontWeight.w900,
                  //                 ),
                  //                 textAlign: TextAlign.left,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       );
                  //     },
                  //   ),
                  // ),
                ],
              ),
            ),
          )),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(36.0),
          ),
          color: navigationColor,
        ),
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Image.asset(
                'assets/menu_icon.png',
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            IconButton(
              icon: Image.asset(
                'assets/profile_icon.png',
                color: Colors.pinkAccent,
              ),
              onPressed: () {
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => DonationScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}

class PaymentMethod {
  final String image;
  final String name;
  final String description;
  final dynamic screen;
  PaymentMethod({this.image, this.name, this.description, this.screen});
}

List<PaymentMethod> myPayments = [
  PaymentMethod(
      description: 'sdfasf',
      image: 'assets/paytm.png',
      name: 'Paytm',
      screen: PaytmScreen()),
  PaymentMethod(
      description: 'sdfasf',
      image: 'assets/paypal.png',
      name: 'Paypal',
      screen: PaypalScreen()),
  PaymentMethod(
      description: 'sdfasf',
      image: 'assets/google.png',
      name: 'GooglePay',
      screen: GooglePayScreen()),
  PaymentMethod(
      description: 'sdfasf',
      image: 'assets/phonepe.png',
      name: 'Phonepe',
      screen: PhonepeScreen()),
];
