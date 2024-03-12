import 'package:flutter/material.dart';
import 'threed.dart';

class Select extends StatefulWidget {
  const Select({super.key});

  @override
  State<Select> createState() => _SelectState();
}

class _SelectState extends State<Select> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('운동 선택'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ThreeD(
                              name: '스쿼트',
                              englishName: 'squat',
                              muscleName: '근')));
                },
                child: Text('스쿼트 자세 배우기')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ThreeD(
                              name: '벤치 프레스',
                              englishName: 'bench press',
                              muscleName: '근')));
                },
                child: Text('벤치 프레스 자세 배우기')),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ThreeD(
                              name: '데드 리프트',
                              englishName: 'dead lift',
                              muscleName: '근')));
                },
                child: Text('데드 리프트 자세 배우기'))
          ],
        ),
      ),
    );
  }
}
