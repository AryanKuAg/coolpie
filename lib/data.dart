import 'package:flutter_universe/specificApiScreen/advice/adviceScreen.dart';
import 'package:flutter_universe/specificApiScreen/chucknorris/chuckNorrisScreen.dart';
import 'package:flutter_universe/specificApiScreen/numbers/numbersScreen.dart';
import 'package:flutter_universe/specificApiScreen/pokemon/main.dart';
import 'package:flutter_universe/specificApiScreen/tronalddump/tronalddumpScreen.dart';

class ApiInfo {
  final int position;
  final String name;
  final String iconImage;
  final String description;
  final dynamic page;

  ApiInfo(this.position,
      {this.name, this.iconImage, this.description, this.page});
}

List<ApiInfo> apis = [
  ApiInfo(
    1,
    name: 'Chuck Norris',
    iconImage: 'assets/chucknorris.png',
    description: "Cool Facts of Chunk Norris",
    page: ChuckNorrisScreen(),
  ),
  ApiInfo(
    2,
    name: 'Numbers',
    iconImage: 'assets/math.png',
    description: "Interesting facts about numbers",
    page: NumbersScreen(),
  ),
  ApiInfo(
    3,
    name: 'Tronald Dump',
    iconImage: 'assets/tronalddump.png',
    description: "What Donald Trump think about something",
    page: TronalddumpScreen(),
  ),
  ApiInfo(
    4,
    name: 'Pokémon',
    iconImage: 'assets/pokemon.png',
    description: "All the Pokémon data you’ll ever need!",
    page: HomePage(),
  ),
  ApiInfo(
    5,
    name: 'Advice',
    iconImage: 'assets/advice.png',
    description: "All the advices you need in your life!",
    page: AdviceScreen(),
  ),
];
