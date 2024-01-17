import 'package:flutter/material.dart';

class AI_recommend extends StatefulWidget {
  const AI_recommend({super.key});

  @override
  State<AI_recommend> createState() => _HomePageState();
}

class _HomePageState extends State<AI_recommend> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '운동 보조식품 추천 AI',
      style: const TextStyle(fontSize: 18),
    );
  }
}