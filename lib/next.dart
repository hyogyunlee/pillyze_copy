import 'package:flutter/material.dart';

class next extends StatefulWidget {
  const next({super.key});

  @override
  State<next> createState() => _HomePageState();
}

class _HomePageState extends State<next> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const SafeArea(
      child: Scaffold(
        body: Text('success'),
      ),
    );
  }
}