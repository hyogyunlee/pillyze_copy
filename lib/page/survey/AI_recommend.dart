import 'package:flutter/material.dart';
import 'package:pillyze_copy/page/survey/AI.dart';

class AI_recommend extends StatefulWidget {
  final String loginMethod;
  const AI_recommend({super.key, required this.loginMethod});

  @override
  State<AI_recommend> createState() => _HomePageState();
}

class _HomePageState extends State<AI_recommend> {

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '운동 보조식품 추천 AI',
            style: const TextStyle(fontSize: 40),
          ),
          ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AI(loginMethod:widget.loginMethod),
                  ),
                );
              },
              child: Text('기본 정보 입력 후\nAI 분석 결과 보기', style: TextStyle(fontSize: 30, color: Colors.black),)
          ),
        ],
      ),
    );
  }
}