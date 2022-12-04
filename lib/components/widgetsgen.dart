// ignore_for_file: prefer_interpolation_to_compose_strings, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:html/parser.dart';
import '../Models/model.dart';
import '../Controllers/home_controller.dart';

hexStringToColor(String hexColor) {
  hexColor = hexColor.toUpperCase().replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF" + hexColor;
  }
  return Color(int.parse(hexColor, radix: 16));
}

Image logoWidget(String imageName) {
  return Image.asset(
    imageName,
    fit: BoxFit.fitWidth,
    width: 240,
    height: 240,
    color: Colors.white,
  );
}

TextField reusableTextField(String text, IconData icon, bool isPasswordType,
    TextEditingController controller) {
  return TextField(
    controller: controller,
    obscureText: isPasswordType,
    enableSuggestions: !isPasswordType,
    autocorrect: !isPasswordType,
    cursorColor: Colors.white,
    style: TextStyle(color: Colors.white.withOpacity(0.9)),
    decoration: InputDecoration(
      prefixIcon: Icon(
        icon,
        color: Colors.white70,
      ),
      labelText: text,
      labelStyle: TextStyle(color: Colors.white.withOpacity(0.9)),
      filled: true,
      floatingLabelBehavior: FloatingLabelBehavior.never,
      fillColor: Colors.white.withOpacity(0.3),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30.0),
          borderSide: const BorderSide(width: 0, style: BorderStyle.none)),
    ),
    keyboardType: isPasswordType
        ? TextInputType.visiblePassword
        : TextInputType.emailAddress,
  );
}

Container firebaseUIButton(BuildContext context, String title, Function onTap) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: 50,
    margin: const EdgeInsets.fromLTRB(0, 10, 0, 20),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(90)),
    child: ElevatedButton(
      onPressed: () {
        onTap();
      },
      child: Text(
        title,
        style: const TextStyle(
            color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return Colors.black26;
            }
            return Colors.white;
          }),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
    ),
  );
}

class RecipeWidget extends StatefulWidget {
  final Recipes recipe;

  RecipeWidget({Key? key, required this.recipe,}) : super(key: key);

  @override
  State<RecipeWidget> createState() => _RecipeWidgetState();
}

class _RecipeWidgetState extends State<RecipeWidget> {
  HomeController homeController = Get.put(HomeController());
  String isVegetarian = '';
  Future<bool> onLikeTapped(isLiked) async {
    if (isLiked) {
      homeController.deleteFromWishlist(docid: widget.recipe.id.toString());
    } else {
      await homeController.addToWishlist(recipe: widget.recipe);
    }
    return !isLiked;
  }

  var isLiked = false.obs;
  @override
  Widget build(BuildContext context) {
    if (widget.recipe.vegetarian != null) {
      isVegetarian = widget.recipe.vegetarian ? "Vegetarian" : "Non-Vegetarian";
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => RecipeInfo(
                      id: widget.recipe.id.toString(),
                      imgUrl: widget.recipe.image,
                      title: widget.recipe.title,
                      summary: widget.recipe.summary,
                      instructions: widget.recipe.instructions,
                      recipefav: widget.recipe,
                    )));
      },
      child: Container(
        margin: const EdgeInsets.all(15),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.recipe.image!,
                    height: 125,
                    width: 125,
                    fit: BoxFit.cover,
                  )),
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.recipe.title!,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    isVegetarian == "Vegetarian"
                        ? Text("Vegetarian",
                            style: TextStyle(color: Colors.green))
                        : Text("Non-Vegetarian",
                            style: TextStyle(color: Colors.red)),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: LikeButton(
                        onTap: onLikeTapped,
                      ),
                    ),
                  ],
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}

class RecipeInfo extends StatefulWidget {
  final Recipes recipefav;
  final String? id;
  final String? imgUrl;
  final String? title;
  final String? instructions;
  final String? summary;
  const RecipeInfo(
      {Key? key,
      required this.id,
      required this.imgUrl,
      required this.title,
      required this.instructions,
      required this.summary,
      required this.recipefav})
      : super(key: key);

  @override
  State<RecipeInfo> createState() => _RecipeInfoState();
}

class _RecipeInfoState extends State<RecipeInfo> {
  HomeController homeController = Get.put(HomeController());
  Future<bool> onLikeTapped(isLiked) async {
    if (isLiked) {
      homeController.deleteFromWishlist(docid: widget.recipefav.id.toString());
    } else {
      await homeController.addToWishlist(recipe: widget.recipefav);
    }
    return !isLiked;
  }

  var isLiked = false.obs;

  @override
  Widget build(BuildContext context) {
    final document = parse(widget.summary);
    String summary = parse(document.body!.text).documentElement!.text;
    return Scaffold(
        backgroundColor: Colors.grey[200],
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(children: [
                  Image.network(
                    widget.imgUrl!,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.4,
                    fit: BoxFit.fill,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.all(15),
                          margin: EdgeInsets.only(left: 15, top: 15),
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          homeController.addToWishlist(
                              recipe: widget.recipefav!);
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          margin: EdgeInsets.only(right: 15, top: 15),
                          child: LikeButton(
                            onTap: onLikeTapped,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
                SizedBox(
                  width: double.infinity,
                  child: Container(
                    padding: const EdgeInsets.all(15.0),
                    margin: EdgeInsets.all(15),
                    child: Text(
                      widget.title!,
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                Card(
                  margin: EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(
                          "Summary: ",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w700),
                        ),
                        Text(
                          summary,
                          style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              wordSpacing: 1.2),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
