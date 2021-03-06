import 'package:flutter_universe/specificApiScreen/chucknorris/chuckNorrisScreen.dart';

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
    name: 'Chuck Norris',
    iconImage: 'assets/chucknorris.png',
    description: "Cool Facts of Chunk Norris",
    page: ChuckNorrisScreen(),
  ),
  ApiInfo(
    3,
    name: 'Chuck Norris',
    iconImage: 'assets/chucknorris.png',
    description: "Cool Facts of Chunk Norris",
    page: ChuckNorrisScreen(),
  ),
];
