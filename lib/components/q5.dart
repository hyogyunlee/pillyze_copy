import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';
import 'package:pillyze_copy/data.dart';

class Q5 extends StatefulWidget {
  const Q5({Key? key}) : super(key: key);

  @override
  State<Q5> createState() => _Q5State();
}

class _Q5State extends State<Q5> {
  List<bool> select = [false, false, false, false, false];
  Color basicColor = Color.fromARGB(255, 250, 230, 213);
  bool nextButtonPressed = false;

  GlobalKey<FlipCardState> cardKey = GlobalKey<FlipCardState>();

  List<String> selectedItems = [];

  void selected(int num) {
    setState(() {
      if (select[num]) {
        select[num] = false;
        selectedItems.remove(getTitle(num));
      } else {
        select[num] = true;
        selectedItems.add(getTitle(num));
      }
    });
  }

  String getTitle(int index) {
    switch (index) {
      case 0:
        return '단백질 보충제';
      case 1:
        return '크레아틴';
      case 2:
        return 'BCAA';
      case 3:
        return '아르기닌';
      case 4:
        return '부스터';
      default:
        return '';
    }
  }

  void onNextButtonPressed() {
    nextButtonPressed = true;
    Data.staticQ5 = true;

    if (selectedItems.isEmpty) {
      return;
    }

    print('선택한 보조식품: $selectedItems');
    cardKey.currentState?.toggleCard();
  }

  void onRestorePagePressed() {
    setState(() {
      select = List.generate(select.length, (_) => false);
      selectedItems.clear();
      Data.staticQ5 = false;
    });
    cardKey.currentState?.toggleCard();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    selectBox(int num, String title, String ex) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 14.0),
        child: InkWell(
          onTap: () {
            selected(num);
          },
          child: Container(
            width: width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: select[num] ? Colors.black : basicColor,
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: select[num] ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  ex,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: select[num] ? Colors.white : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        FlipCard(
          key: cardKey,
          flipOnTouch: false,
          fill: Fill.fillBack,
          direction: FlipDirection.VERTICAL,
          side: CardSide.FRONT,
          front: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(13),
              ),
              padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(bottom: 0.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Q5.',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: onNextButtonPressed,
                              child: Text('다음', style: TextStyle(color:Colors.black)),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          '어떤 운동 보조식품을\n섭취하고 싶으신가요?',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          '여러가지 선택이 가능합니다!',
                          style: TextStyle(fontSize: 13),
                        ),
                        SizedBox(height: 5,)
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      selectBox(0, '단백질 보충제  ', '(부족한 단백질을 채워줘요)'),
                      selectBox(1, '크레아틴  ', '(근육이 더 커져요)'),
                      selectBox(2, 'BCAA  ', '(근육의 합성을 도와줘요)'),
                      selectBox(3, '아르기닌  ', '(혈액순환을 촉진시켜요)'),
                      selectBox(4, '부스터  ', '(더 높은 기록을 세울 수 있게 도와줘요)'),
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
                color: Colors.deepPurple[100],
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage('assets/info_Q5.png'),
                  alignment: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Spacer(),
                        InkWell(
                          onTap: onRestorePagePressed,
                          child: const Icon(
                            Icons.restore_page,
                            size: 30,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      selectedItems.map((item) => '    - $item').join('\n'),
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}