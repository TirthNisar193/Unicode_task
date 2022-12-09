
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:like_button/like_button.dart';
import '../../Models/getRequest.dart';
import '../../Models/model.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List<Recipes>? recipeList;
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          icon: Icon(Icons.clear))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.arrow_back_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder(
        future: getData(query: query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: recipeList!.length.compareTo(0),
            itemBuilder: (BuildContext context, int index) {
              Recipes recipe = recipeList![index];
              return RecipeDe(
                title: recipe.title!,
                imgUrl: recipe.image!,
                isVeg: recipe.vegetarian,
                summary: recipe.summary.toString(),
                time: recipe.cookingMinutes,
              );
            },
            separatorBuilder: (context, index) {
              return SizedBox(
                height: 5,
              );
            },
          );
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
   return FutureBuilder(
        future: getData(query: query),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView.separated(
            shrinkWrap: true,
            itemCount: recipeList!.length,
            itemBuilder: (BuildContext context, int index) {
              Recipes recipe = recipeList![index];
              return RecipeDe(
                title: recipe.title!,
                imgUrl: recipe.image!,
                isVeg: !recipe.vegetarian,
                summary: recipe.summary.toString(),
                time: recipe.cookingMinutes,
              );
            },
            separatorBuilder: (context,index){
              return SizedBox(height: 5,);
            },
          );
        }
    );
  }

  getData({required String? query}) async {
    recipeList = await ApiServices().getData(query)!;
  }
}


class RecipeDe extends StatelessWidget {
  final String title;
  final String imgUrl;
  final bool isVeg;
  final String summary;
  final int time;
  const RecipeDe(
      {Key? key,
      required this.title,
      required this.imgUrl,
      required this.isVeg,
      required this.summary,
      required this.time})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        subtitle: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    imgUrl,
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
                  title,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    isVeg
                        ? Text("Vegetarian",
                            style: TextStyle(color: Colors.green.shade300))
                        : Text("Non-Vegetarian",
                            style: TextStyle(color: Colors.red.shade300)),
                    LikeButton(),
                  ],
                ),
              ],
            ))
          ],
        ),
      onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => RecipeInfo2(
                          title: title,
                          image: imgUrl,
                          isVeg: isVeg,
                          summary: summary,
                          time: time,
                        )));
              },
      ),
    
    );
  }
}
class RecipeInfo2 extends StatelessWidget {
  String summary;
  String title;
  String image;
  int time;
  bool isVeg;
  RecipeInfo2(
      {Key? key,
      required this.title,
      required this.image,
      required this.time,
      required this.isVeg,
      required this.summary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text("Recipe Information"),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Image.network(image),
          Text(
            title,
            style: const TextStyle(fontSize: 30.0, fontWeight: FontWeight.w500),
          ),
          Html(
            data: summary,
          )
        ],
      )),
    ));
  }
}