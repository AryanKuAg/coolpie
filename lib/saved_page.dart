// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_swiper/flutter_swiper.dart';
// import 'package:flutter_tindercard/flutter_tindercard.dart';
// import 'package:flutter_universe/constants.dart';
// import 'package:flutter_universe/data.dart';
// import 'package:flutter_universe/localDatabase.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:lottie/lottie.dart';
//
// Future<List<LocalSavedValue>> fetchLocalSavedValueFromDatabase() async {
//   LocalDatabase localDatabase = LocalDatabase();
//   Future<List<LocalSavedValue>> savedValues =
//       localDatabase.getLocalSavedValue();
//
//   return savedValues;
// }
//
// class SavedPage extends StatefulWidget {
//   @override
//   _SavedPageState createState() => _SavedPageState();
// }
//
// class _SavedPageState extends State<SavedPage> {
//   @override
//   Widget build(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context).size;
//     final textScaleFactor = MediaQuery.of(context).textScaleFactor;
//     return Scaffold(
//       backgroundColor: gradientEndColor,
//       body: Container(
//         decoration: BoxDecoration(
//             gradient: LinearGradient(
//                 colors: [gradientStartColor, gradientEndColor],
//                 begin: Alignment.topCenter,
//                 end: Alignment.bottomCenter,
//                 stops: [0.3, 0.7])),
//         child: SafeArea(
//           child: FutureBuilder(
//               future: fetchLocalSavedValueFromDatabase(),
//               builder: (context, snapshot) {
//                 if (snapshot.connectionState == ConnectionState.waiting) {
//                   return Center(child: Lottie.asset('assets/nodata.json'));
//                 }
//
//                 if (snapshot.hasData) {
//                   return Center(
//                     child: SizedBox(
//                       height: 300,
//                       width: double.infinity,
//                       child: TinderSwapCard(
//                         swipeUp: true,
//                         swipeDown: true,
//                         orientation: AmassOrientation.BOTTOM,
//                         totalNum: snapshot.data.length,
//                         stackNum: 3,
//                         swipeEdge: 4.0,
//                         maxWidth: MediaQuery.of(context).size.width * 0.9,
//                         maxHeight: MediaQuery.of(context).size.width * 0.9,
//                         minWidth: MediaQuery.of(context).size.width * 0.8,
//                         minHeight: MediaQuery.of(context).size.width * 0.8,
//                         cardBuilder: (context, index) {
//                           LocalSavedValue localSavedValue =
//                               snapshot.data[index];
//                           return Stack(
//                             alignment: Alignment.center,
//                             children: [
//                               Card(
//                                 child: Opacity(
//                                   opacity: 0.2,
//                                   child: Container(
//                                     height: 270, width: 270,
//                                     // padding: const EdgeInsets.all(120),
//                                     child: CachedNetworkImage(
//                                         imageUrl: '${localSavedValue.image}'),
//                                   ),
//                                 ),
//                               ),
//                               if (localSavedValue.image != '')
//                                 Positioned(
//                                   left: mediaQuery.width / 3 + 10,
//                                   top: 5,
//                                   child: CachedNetworkImage(
//                                     imageUrl: localSavedValue.image,
//                                     height: 50,
//                                     width: 50,
//                                     alignment: Alignment.topCenter,
//                                   ),
//                                 ),
//                               if (localSavedValue.value != '')
//                                 Positioned(
//                                   bottom: 80,
//                                   child: Container(
//                                     margin: const EdgeInsets.only(top: 50),
//                                     padding: const EdgeInsets.symmetric(
//                                         vertical: 10, horizontal: 20),
//                                     width: 300,
//                                     child: Text(
//                                       localSavedValue.value.toString(),
//                                       style: GoogleFonts.acme(
//                                           color: Colors.black.withOpacity(0.7),
//                                           wordSpacing: 1.2,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize: textScaleFactor * 20),
//                                       // style: TextStyle(
//                                       //     fontSize: 20, fontWeight: FontWeight.bold),
//                                       textAlign: TextAlign.center,
//                                     ),
//                                   ),
//                                 ),
//                             ],
//                           );
//                         },
//                         cardController: CardController(),
//                         swipeUpdateCallback:
//                             (DragUpdateDetails details, Alignment align) {
//                           /// Get swiping card's alignment
//                           if (align.x < 0) {
//                             //Card is LEFT swiping
//                           } else if (align.x > 0) {
//                             //Card is RIGHT swiping
//                           }
//                         },
//                         swipeCompleteCallback:
//                             (CardSwipeOrientation orientation, int index) {
//                           /// Get orientation & index of swiped card!
//                         },
//                       ),
//                     ),
//                   );
//                 } else if (snapshot.data.length == 0) {
//                   return Lottie.asset('assets/nodata.json');
//                 }
//                 return Container(
//                   alignment: AlignmentDirectional.center,
//                   child: Lottie.asset('assets/nodata.json'),
//                 );
//               }),
//         ),
//       ),
//       bottomNavigationBar: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.vertical(
//             top: Radius.circular(36.0),
//           ),
//           color: navigationColor,
//         ),
//         padding: const EdgeInsets.all(24),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: <Widget>[
//             IconButton(
//               icon: Image.asset(
//                 'assets/menu_icon.png',
//                 color: Colors.white38,
//               ),
//               onPressed: () {},
//             ),
//             IconButton(
//               icon: Image.asset(
//                 'assets/search_icon.png',
//                 color: Colors.blue,
//               ),
//               onPressed: () {
//                 Navigator.push(
//                     context, MaterialPageRoute(builder: (ctx) => SavedPage()));
//               },
//             ),
//             IconButton(
//               icon: Image.asset('assets/profile_icon.png'),
//               onPressed: () {},
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
