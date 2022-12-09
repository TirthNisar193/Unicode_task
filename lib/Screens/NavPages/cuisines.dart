// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

import 'cuisines_list.dart';

class CuisinesPage extends StatefulWidget {
  const CuisinesPage({Key? key}) : super(key: key);

  @override
  State<CuisinesPage> createState() => _CuisinesPageState();
}

class _CuisinesPageState extends State<CuisinesPage> {
  List<String> cuisinesList = [
    "Indian",
    "Thai",
    "Chinese",
    "Japanese",
    "French",
    "Italian",
    "Greek",
    "Korean",
    "British",
    "Mediterranean",
    "Mexican"
  ];
  List<String> imgPaths = [
    "indian.jpg",
    "thai.jpg",
    "chinese.jpg",
    "japanese.jpg",
    "french.jpg",
    "italian.jpg",
    "greek.jpg",
    "korean.jpg",
    "british.jpg",
    "mediterranean.jpg",
    "mexican.jpg"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
          child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListView.builder(
              shrinkWrap: true,
              itemCount: cuisinesList.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return CuisinesWidget(
                    imgPath: imgPaths[index], title: cuisinesList[index]);
              },
            )
          ],
        ),
      )),
    );
  }
}

class CuisinesWidget extends StatelessWidget {
  final String imgPath;
  final String title;
  const CuisinesWidget({Key? key, required this.imgPath, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CuisinesList(cuisine: title)));
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.3,
            child: Stack(
              alignment: Alignment.center,
              children: [
                ConstrainedBox(
                  constraints: BoxConstraints.expand(),
                  child: Image.asset(
                    'Assets/images/$imgPath',
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.grey.shade400.withOpacity(0.8),
                  ),
                  child: Text(
                    title,
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                        color: Colors.white),
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
