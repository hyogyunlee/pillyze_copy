import 'package:flutter/material.dart';
import 'package:pillyze_copy/page/survey/pad/info_page_pad.dart';

class StartPage_pad extends StatefulWidget {
  final String loginMethod;
  const StartPage_pad({super.key, required this.loginMethod});

  @override
  State<StartPage_pad> createState() => _StartPage_pad_State();
}
class _StartPage_pad_State extends State<StartPage_pad>{
  @override
  Widget build(BuildContext context) {
    stepBox(String step, String stepTitle) {
      return Container(
        child: Column(
          children: [
            Text(step,
                style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.w600)),
            Text(stepTitle,
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.w600))
          ],
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 132, 255, 1),
        surfaceTintColor: Colors.white,
        title: Image.asset('assets/maida.png',width: 250, height: 250,),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(

            image: AssetImage('assets/main.png'),

            fit: BoxFit.contain,

            alignment: Alignment.center,

          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 40),
              child: Text(
                '헬스테일러 AI 운동 보조식품 추천 서비스',
                style: TextStyle(
                    fontSize: 40, fontWeight: FontWeight.w600),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                stepBox('step1', '신체 정보 입력'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: 80,
                    height: 5,
                    color: Colors.black,
                  ),
                ),
                stepBox('step2', '질병 부작용 설문조사'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Container(
                    width: 80,
                    height: 5,
                    color: Colors.black,
                  ),
                ),
                stepBox('step3', 'AI 결과 분석')
              ],
            ),
            const Spacer(),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InfoPage_pad(loginMethod: widget.loginMethod,),
                    ));
              },
              child: SizedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('분석시작 ',
                        style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.w700)),
                    Icon(
                      Icons.arrow_circle_right_outlined,
                      size: 30,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 80,),
          ],
        ),
      ),
    );
  }
}
