import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:pillyze_copy/page/survey/pad/result_page_pad.dart';

class LifeStylePage_pad extends StatefulWidget {
  final String loginMethod;
  const LifeStylePage_pad({super.key, required this.loginMethod});
  @override
  State<LifeStylePage_pad> createState() => _LifeStylePage_pad_State();
}

class _LifeStylePage_pad_State extends State<LifeStylePage_pad> {
  CarouselController carouselController = CarouselController();
  int _current = 0;
  Map<int, String> _selectedOptions = {};
  final List<Map<String, dynamic>> _surveyData = [
    {
      'question': 'Q1.\n운동 보조식품을\n섭취해서 부작용을\n경험한 적이 있나요?',
      'options': ['O', 'X'],
      'imagePath': 'assets/Q1.png',
      'color': Colors.teal
    },
    {
      'question': 'Q2.\n운동 보조식품이\n맞지 않아서\n버린 경험이 있나요?',
      'options': ['O', 'X'],
      'imagePath': 'assets/Q2.png',
      'color': Colors.amber
    },
    {
      'question': 'Q3.\n가지고 있는 질병이나\n먹는 약이 있나요?',
      'options': ['O', 'X'],
      'imagePath': 'assets/Q3.png',
      'color': Colors.brown
    },
    {
      'question': 'Q4.\n웨이트 트레이닝을\n하다가 다친\n경험이 있나요?',
      'options': ['O', 'X'],
      'imagePath': 'assets/Q4.png',
      'color': Colors.purpleAccent
    },
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 132, 255, 1),
        surfaceTintColor: Colors.white,
        title: Image.asset('assets/maida.png',width: 250, height: 250,),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 30, bottom: 100),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Step 2. 질병, 부작용 설문조사',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                maxLines: 1,
              ),
              const Text(
                '그동안의 경험을 알려주세요.',
                textAlign: TextAlign.center,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                maxLines: 1,
              ),
              const SizedBox(
                height: 20,
              ),
              CarouselSlider(
                carouselController: carouselController,
                items: _surveyData.map((survey) {
                  String question = survey['question'] as String;
                  List<String> options = survey['options'] as List<String>;
                  String imagePath = survey['imagePath'] as String;
                  Color color = survey['color'] as Color;
                  int index = _surveyData.indexOf(survey);
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: 500,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(imagePath),
                            alignment: Alignment.center,
                          ),
                          color: color,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                question,
                                style: const TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: options
                                    .asMap()
                                    .entries
                                    .map<Widget>((entry) {
                                  String option = entry.value;
                                  bool isSelected =
                                      _selectedOptions.containsKey(index) &&
                                          _selectedOptions[index] == option;
                                  return Row(
                                    children: [
                                      Container(
                                        width: 80,
                                        height: 80,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                        ),
                                        child: ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              _selectedOptions[index] = option;
                                            });
                                            goToNextQuestion();
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: const CircleBorder(),
                                            primary: isSelected
                                                ? Colors.black
                                                : Colors.white,
                                          ),
                                          child: Center(
                                            child: Text(
                                              option,
                                              style: TextStyle(
                                                  color: isSelected
                                                      ? Colors.white
                                                      : color,
                                                  fontSize: 40,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 400,
                  viewportFraction: 0.6,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  reverse: false,
                  autoPlayCurve: Curves.elasticOut,
                  enlargeCenterPage: true,
                  scrollDirection: Axis.horizontal,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: SizedBox(
                  width: 500,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(490, 20),
                        painter: LinePainter(),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: _surveyData.asMap().entries.map((entry) {
                          int index = entry.key;
                          return GestureDetector(
                            onTap: () =>
                                carouselController.animateToPage(index),
                            child: Stack(
                              children: [
                                Container(
                                  width: _current == index ? 24.0 : 12.0,
                                  height: _current == index ? 24.0 : 12.0,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _current == index
                                        ? _surveyData[index]['color']
                                        : Colors.black,
                                  ),
                                ),
                                if (_current == index)
                                  const Icon(
                                    Icons.graphic_eq_rounded,
                                    color: Colors.white,
                                    size: 24.0,
                                  ),
                                if (_current != index &&
                                    _selectedOptions.containsKey(index))
                                  const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 12.0,
                                  ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              if (isAllQuestionsAnswered() &&
                  _selectedOptions.containsKey(_current))
                Padding(
                  padding: const EdgeInsets.only(bottom: 100.0),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ResultPage_pad(loginMethod: widget.loginMethod,),
                          ));
                    },
                    child: const Text(
                      '결과보기',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
  void goToNextQuestion() {
    // 선택되지 않은 가장 앞의 질문으로 이동
    for (int i = 0; i < _surveyData.length; i++) {
      if (!_selectedOptions.containsKey(i)) {
        carouselController.animateToPage(i);
        setState(() {
          _current = i;
        });
        return;
      }
    }
  }
  bool isAllQuestionsAnswered() {
    return _selectedOptions.length == _surveyData.length;
  }
}

class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1
      ..strokeCap = StrokeCap.round;
    var startPoint = Offset(0, size.height / 2);
    var endPoint = Offset(size.width, size.height / 2);
    canvas.drawLine(startPoint, endPoint, paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}