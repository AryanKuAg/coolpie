import 'package:flutter_universe/specificApiScreen/chucknorris/chuckNorrisScreen.dart';
import 'package:flutter_universe/specificApiScreen/numbers/numbersScreen.dart';

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
];
