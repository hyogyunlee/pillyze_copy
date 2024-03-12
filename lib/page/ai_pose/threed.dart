import 'package:flutter/material.dart';
import 'pad.dart';
import 'mobile.dart';

class ThreeD extends StatefulWidget {
  final String name;
  final String englishName;
  final String muscleName;
  const ThreeD(
      {super.key,
      required this.name,
      required this.englishName,
      required this.muscleName});

  @override
  _ThreeDState createState() => _ThreeDState();
}

class _ThreeDState extends State<ThreeD> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (screenWidth > 600) {
            // 태블릿 화면 넓이 일 때 보여줄 UI
            return Pad(
                name: widget.name,
                englishName: widget.englishName,
                muscleName: widget.muscleName);
          } else {
            // 모바일 화면 넓이 일 때 보여줄 UI
            return mobile(
                name: widget.name,
                englishName: widget.englishName,
                muscleName: widget.muscleName);
          }
        },
      ),
    );
  }
}
