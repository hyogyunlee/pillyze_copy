import 'package:flutter/material.dart';
import 'package:pillyze_copy/page/survey/mobile/start_page_mobile.dart';
import 'package:pillyze_copy/page/survey/pad/start_page_pad.dart';

class AI extends StatefulWidget {
  final String loginMethod;
  const AI({super.key, required this.loginMethod});

  @override
  State<AI> createState() => _AIState();
}

class _AIState extends State<AI> with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (screenWidth > 600) {
            // 태블릿 화면 넓이 일 때 보여줄 UI
            return StartPage_pad(loginMethod:widget.loginMethod);
          } else {
            // 모바일 화면 넓이 일 때 보여줄 UI
            return StartPage(loginMethod:widget.loginMethod);
          }
        },
      ),
    );
  }
}
