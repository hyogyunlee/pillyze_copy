import 'package:flutter/material.dart';
import 'package:pillyze_copy/page/survey/mobile/start_page_mobile.dart';

class AI_recommend extends StatefulWidget {
  final String loginMethod;
  const AI_recommend({super.key, required this.loginMethod});

  @override
  State<AI_recommend> createState() => _HomePageState();
}

class _HomePageState extends State<AI_recommend> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '운동 보조식품 추천 AI',
          style: const TextStyle(fontSize: 18),
        ),
        ElevatedButton(
            onPressed: (){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StartPage(loginMethod: widget.loginMethod),
                ),
              );
            },
            child: Text('기본 정보 입력')
        ),
      ],
    );
  }
}