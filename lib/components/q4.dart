import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:pillyze_copy/data.dart';

class Q4 extends StatefulWidget {
  const Q4({super.key});

  @override
  State<Q4> createState() => _Q4State();
}

class _Q4State extends State<Q4> {
  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  bool canFlip = false;

  String height = '';
  String weight = '';

  final textEditController_height = TextEditingController();
  final textEditController_weight = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FlipCard(
      key: cardKey,
      flipOnTouch: false,
      fill: Fill.fillBack,
      direction: FlipDirection.VERTICAL,
      side: CardSide.FRONT,
      front: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(13)),
          padding: const EdgeInsets.fromLTRB(20, 15, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q4.',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '키와 몸무게를\n알려주세요',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                            onEditingComplete: () {
                              setState(() {
                                Data.staticQ4 = true;
                                Data.staticHeight = textEditController_height.text;
                                height = textEditController_height.text;
                                weight = textEditController_weight.text; // 여기서도 weight 업데이트
                              });
                              Future.delayed(const Duration(seconds: 1), () {
                                cardKey.currentState?.toggleCard();
                              });
                            },
                            controller: textEditController_height,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          )),
                      const Text(
                        'cm',
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                            onEditingComplete: () {
                              setState(() {
                                Data.staticQ4 = true;
                                Data.staticWeight = textEditController_weight.text;
                                height = textEditController_height.text; // 여기서도 height 업데이트
                                weight = textEditController_weight.text;
                              });
                              Future.delayed(const Duration(seconds: 1), () {
                                cardKey.currentState?.toggleCard();
                              });
                            },
                            controller: textEditController_weight,
                            decoration: const InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black)),
                              enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.grey),
                              ),
                            ),
                          )),
                      const Text(
                        'kg',
                        style: TextStyle(fontSize: 18),
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      back: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage('assets/info_Q4.png'),
              alignment: Alignment.topRight,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          text: TextSpan(children: [
                            const TextSpan(
                                text: ' 키 ',
                                style: TextStyle(fontSize: 20, color: Colors.black)),
                            TextSpan(
                                text: height,
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600)),
                            const TextSpan(
                                text: ' cm',
                                style: TextStyle(fontSize: 20, color: Colors.black)),
                          ]
                          ),
                        ),
                        Row(
                          children: [
                            RichText(
                              text: TextSpan(children: [
                                const TextSpan(
                                    text: ' 몸무게 ',
                                    style: TextStyle(fontSize: 20, color: Colors.black)),
                                TextSpan(
                                    text: weight,
                                    style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 25,
                                        fontWeight: FontWeight.w600)),
                                const TextSpan(
                                    text: ' kg',
                                    style: TextStyle(fontSize: 20, color: Colors.black)),
                              ]
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  textEditController_height.clear();
                                  textEditController_weight.clear();
                                  Data.staticQ4 = false;
                                });
                                cardKey.currentState?.toggleCard();
                              },
                              child: const Icon(
                                Icons.restore_page,
                                size: 30,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}