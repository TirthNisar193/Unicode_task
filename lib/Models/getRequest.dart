import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'model.dart';

class ApiServices {
  String? title;
  String? imgUrl;
  bool? isVeg;
  String? summary;
  int? readyInminutes;
  RecipesMain? recipesMain;
  List<Recipes>? _recipesList;

  getData(String? query) async {
    // ignore: prefer_typing_uninitialized_variables
    /* var responseBody;
    String apiKey = "507bb005764140038f545eb46fa00224";
    String baseUrl = "https://api.spoonacular.com/recipes";
    String url = '$baseUrl/random?number=15&apiKey=$apiKey';
    http.Response response = await http.get(Uri.parse(url));

    try {
      if (response.statusCode == 200) {
        responseBody = jsonDecode(response.body);
        //log(responseBody.toString());
        title = responseBody['recipes'][0]['title'];
        imgUrl = responseBody['recipes'][0]['image'];
        isVeg = responseBody['recipes'][0]['vegetarian'];
        debugPrint(title);
        // debugPrint(imgUrl);
        // debugPrint(isVeg.toString());
        var recipesMain = RecipesMain.fromJson(responseBody);
        _recipesList = recipesMain.recipes;
      } else {
        debugPrint(response.statusCode.toString());
      }
      return _recipesList;
    } catch (e) {
      debugPrint(e.toString());
    }
  } */
    http.Response response = await http.get(Uri.parse(
        'https://api.spoonacular.com/recipes/random?apiKey=507bb005764140038f545eb46fa00224&number=20'));
    try {
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(response.statusCode);

        var recipesMain = RecipesMain.fromJson(data);
        _recipesList = recipesMain.recipes;
        if (query != null) {
          _recipesList = _recipesList!
              .where((element) =>
                  element.title!.toLowerCase().contains(query.toLowerCase()))
              .toList();
        }
      } else {
        print(response.statusCode);
      }
      return _recipesList;
    } catch (e) {
      print(e);
    }
  }
}
