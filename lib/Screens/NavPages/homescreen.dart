// ignore_for_file: prefer_const_constructors
import 'package:curious_appetite/Models/model.dart';
import 'package:curious_appetite/Controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../components/widgetsgen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final homecontroller = Get.put(HomeController());
  TextEditingController recipecontroller = TextEditingController();
  /*  List<Recipes> recipelist = [];
  getRecipeData() async {
    recipelist = await ApiServices().getData();
    debugPrint(recipelist.length.toString());
  } */

  @override
  void initState() {
    homecontroller.fetchRecipes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Expanded(
          child: FutureBuilder(
            future: homecontroller.fetchRecipes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Text("LOADING");
              }
              return
                SingleChildScrollView(
                  child: GetX<HomeController>(
                      builder: (homeController) {
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: homeController.recipes.length,
                          itemBuilder: (BuildContext context, int index) {
                            Recipes recipe = homeController.recipes[index];
                            //print(recipe.title);
                            return RecipeWidget(
                              recipe: recipe,
                            );
                          },
                        );
                      },
                    ),
                );
              },
          ),
        )
      ]),
    );
  }
}
