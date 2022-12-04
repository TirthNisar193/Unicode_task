// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import '../../Controllers/home_controller.dart';

class Neubox extends StatefulWidget {
  const Neubox({super.key});

  @override
  State<Neubox> createState() => _NeuboxState();
}

class _NeuboxState extends State<Neubox> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextFormField(
        controller: HomeController().recipeController,
        decoration: InputDecoration(
          suffixIconColor: Colors.black,
          suffixIcon: IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              HomeController().searchRecipes;
            },
          ),
          border: InputBorder.none,
          hintText: "Search",
        ),
      ),
    );
  }
}
