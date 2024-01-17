import 'package:flutter/material.dart';

class AI_3D_posture extends StatefulWidget {
  const AI_3D_posture({super.key});

  @override
  State<AI_3D_posture> createState() => _HomePageState();
}

class _HomePageState extends State<AI_3D_posture> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '3D AI',
      style: const TextStyle(fontSize: 18),
    );
  }
}