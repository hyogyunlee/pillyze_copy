import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:pillyze_copy/data.dart';

class Q2 extends StatefulWidget {
  const Q2({super.key});

  @override
  State<Q2> createState() => _Q2State();
}

class _Q2State extends State<Q2> {
  List<bool> select = [false, false];
  Color basicColor = const Color.fromARGB(255, 250, 230, 213);

  void selected(int idx, int myNum) {
    if (select[idx] == false) {
      setState(() {
        select[myNum] = true;
      });
    }
  }

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();
  bool canFlip = false;

  String sex = '';

  void checkCanFlip() {
    if (select[0] == true || select[1] == true) {
      setState(() {
        Data.staticQ2 = true;
      });

      if (select[0] == true) {
        setState(() {
          sex = '남';
        });
      } else {
        setState(() {
          sex = '여';
        });
      }

      Future.delayed(const Duration(seconds: 1), () {
        cardKey.currentState?.toggleCard();
      });
    }
  }

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
                    'Q2.',
                    style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '성별을\n선택해주세요',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: () {
                      selected(1, 0);
                      checkCanFlip();
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          select[0] == true ? Colors.black : basicColor,
                      child: Text(
                        '남',
                        style: TextStyle(
                            fontSize: 15,
                            color: select[0] == true
                                ? Colors.white
                                : Colors.grey.shade600),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  InkWell(
                    onTap: () {
                      selected(0, 1);
                      checkCanFlip();
                    },
                    child: CircleAvatar(
                      radius: 15,
                      backgroundColor:
                          select[1] == true ? Colors.black : basicColor,
                      child: Text(
                        '여',
                        style: TextStyle(
                            fontSize: 15,
                            color: select[1] == true
                                ? Colors.white
                                : Colors.grey.shade600),
                      ),
                    ),
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
              color: Colors.deepOrange[300],
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(

                image: sex=='남' ? AssetImage('assets/man.png'):AssetImage('assets/woman.png'),

                alignment: Alignment.center,

              ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
             Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      sex,
                      style: const TextStyle(
                          fontSize: 25, fontWeight: FontWeight.w600),
                    ),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            select[0] = false;
                            select[1] = false;
                            Data.staticQ2 = false;
                          });
                          cardKey.currentState?.toggleCard();
                        },
                        child: const Icon(
                          Icons.restore_page,
                          size: 30,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
