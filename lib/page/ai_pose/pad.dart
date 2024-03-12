import 'package:flutter/material.dart';

class Pad extends StatefulWidget {
  final String name;
  final String englishName;
  final String muscleName;
  const Pad({super.key, required this.name, required this.englishName, required this.muscleName});

  @override
  State<Pad> createState() => _PadState();
}

class _PadState extends State<Pad> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Row(
            children: [
              Column(
                children: [
                  Container(
                    padding: EdgeInsets.all(10),
                    width: 400,
                    height: 210,
                    color: Colors.grey.shade200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.menu),
                        Padding(
                          padding: const EdgeInsets.only(top: 40.0),
                          child: Center(
                              child: Text(
                                widget.name,
                                style: TextStyle(fontSize: 30),
                              )),
                        ),
                        Center(child: Text(widget.englishName))
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 400,
                    height: 400,
                    color: Colors.grey.shade200,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 0.0),
                          child: Text.rich(TextSpan(
                              text: '주요 타겟 근육 : ',
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              children: [
                                TextSpan(
                                  text: '${widget.muscleName}',
                                  style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                )
                              ])),
                        ),
                        Text(
                          '목표횟수',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text.rich(TextSpan(
                                text: '0 / 10 ',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: '회',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  )
                                ])),
                            Text.rich(TextSpan(
                                text: '0 / 4 ',
                                style: TextStyle(
                                    fontSize: 22, fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: 'sets',
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal),
                                  )
                                ])),
                          ],
                        ),
                        Column(
                          children: [
                            Column(
                              children: [
                                Text('소모한 칼로리',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                SizedBox(
                                  height: 5,
                                ),
                                Text('000 kcal',
                                    style: TextStyle(fontSize: 20)),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Column(
                              children: [
                                Text('운동 시간',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
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
                  ),
                ],
              ),
              Expanded(
                child: Container(
                  height: 620,
                  color: Colors.grey,
                ),
              )
            ],
          ),
          Container(
            height: 10,
            color: Colors.white,
          ),
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 30),
                  width: 400,
                  height: 190,
                  color: Colors.grey.shade200,
                  child: Row(
                    children: [
                      Text('Tip !',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold)),
                      SizedBox(
                        width: 20,
                      ),
                      Text(' ~~~~')
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 200,
                    color: Colors.white,
                    child: Center(child: Text('graph')),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
