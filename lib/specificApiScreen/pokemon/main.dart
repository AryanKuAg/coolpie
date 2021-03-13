import 'dart:convert';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:flutter_universe/specificApiScreen/advice/adviceScreen.dart';
import 'package:flutter_universe/specificApiScreen/pokemon/pokemon.dart';
import 'package:flutter_universe/specificApiScreen/pokemon/pokemondetail.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  AdmobInterstitial interstitialAd;
  var url =
      "https://raw.githubusercontent.com/Biuni/PokemonGO-Pokedex/master/pokedex.json";

  PokeHub pokeHub;

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
    fetchData();
  }

  fetchData() async {
    var res = await http.get(url);
    var decodedJson = jsonDecode(res.body);
    pokeHub = PokeHub.fromJson(decodedJson);
    print(pokeHub.toJson());
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    interstitialAd.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Poke App"),
        backgroundColor: Colors.cyan,
      ),
      body: pokeHub == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GridView.count(
              crossAxisCount: 2,
              children: pokeHub.pokemon
                  .map((poke) => Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => PokeDetail(
                                          pokemon: poke,
                                        )));
                          },
                          child: Hero(
                            tag: poke.img,
                            child: Card(
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SizedBox(
                                    height: 100,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.3,
                                      width: MediaQuery.of(context).size.width *
                                          0.2,
                                      child: Image.network(poke.img),
                                    ),
                                  ),
                                  Text(
                                    poke.name,
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ))
                  .toList(),
            ),
    );
  }
}
