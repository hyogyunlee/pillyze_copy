import 'package:flutter/material.dart';

class mobile extends StatefulWidget {
  final String name;
  final String englishName;
  final String muscleName;
  const mobile({super.key, required this.name, required this.englishName, required this.muscleName});

  @override
  State<mobile> createState() => _mobileState();
}

class _mobileState extends State<mobile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40),
        child: AppBar(
          backgroundColor: Colors.white,
          leading: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(Icons.menu)),
        ),
      ),
      body: Column(
        children: [
          Text(
            widget.name,
            style: TextStyle(fontSize: 19),
          ),
          Text(
            widget.englishName,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15),
            child: Text.rich(TextSpan(
                text: '주요 타겟 근육 : ${widget.muscleName}',
                style: TextStyle(
                  fontSize: 15,
                ),
                children: [
                  TextSpan(
                    text: '~~~근',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  )
                ])),
          ),
          Container(
            height: 450,
            color: Colors.grey.shade300,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 25, 0, 10),
            child: Text(
              '목표횟수',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text.rich(TextSpan(
                  text: '0 / 10 ',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: '회',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    )
                  ])),
              Text.rich(TextSpan(
                  text: '0 / 4 ',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: 'sets',
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    )
                  ])),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  Text('소모한 칼로리',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 5,
                  ),
                  Text('000 kcal', style: TextStyle(fontSize: 20)),
                ],
              ),
              Column(
                children: [
                  Text('운동 시간',
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  SizedBox(
                    height: 5,
                  ),
                  Text('00:00',
                      style: TextStyle(
                        fontSize: 20,
                      )),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
