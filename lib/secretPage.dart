import 'package:flutter/material.dart';
import 'package:flutter_universe/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecretPage extends StatelessWidget {
  TextEditingController _textEditingController = TextEditingController();

  doneEditing(BuildContext ctx) async {
    Future<SharedPreferences> sharedPreferences =
        SharedPreferences.getInstance();
    SharedPreferences sp = await sharedPreferences;
    if (_textEditingController.text != null &&
        _textEditingController.text.toLowerCase() == 'alemantrix') {
      sp.setString('code', 'alemantrix');
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        backgroundColor: Colors.greenAccent,
        content: Text('Ads Disabled successfully!!!'),
      ));
    } else {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        backgroundColor: Colors.redAccent,
        content: Text("Something isn't right!"),
      ));

      print(sp.get('code'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [gradientStartColor, gradientEndColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.3, 0.7])),
            child: Center(
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                    border: Border.all(width: 2, color: Colors.white),
                    borderRadius: BorderRadius.circular(20),
                    color: gradientEndColor),
                child: TextField(
                  controller: _textEditingController,
                  showCursor: false,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  onEditingComplete: () => doneEditing(context),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(border: InputBorder.none),
                ),
              ),
            )));
  }
}
