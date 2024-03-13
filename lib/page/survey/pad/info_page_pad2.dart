import 'package:flutter/material.dart';
import 'package:pillyze_copy/components/q5.dart';
import 'package:pillyze_copy/data.dart';
import 'package:pillyze_copy/page/survey/pad/lifeStyle_page_pad.dart';

class InfoPage2_pad extends StatefulWidget {
  final String loginMethod;
  const InfoPage2_pad({super.key, required this.loginMethod});

  @override
  State<InfoPage2_pad> createState() => _InfoPage2_pad_State();
}

class _InfoPage2_pad_State extends State<InfoPage2_pad> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(0, 132, 255, 1),
        surfaceTintColor: Colors.white,
        title: Image.asset('assets/maida.png',width: 250, height: 250,),
      ),
      backgroundColor: const Color.fromARGB(255, 198, 233, 235),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'STEP 1. 신체 정보 입력',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Text(
                  '당신은 어떤 사람인가요?',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(
                  width: 550,
                  height: 550,
                  child: Q5()
              ),
              InkWell(
                onTap: () {
                  if (Data.staticQ5 == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LifeStylePage_pad(loginMethod: widget.loginMethod,),
                        ));
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return const AlertDialog(
                          backgroundColor: Colors.white,
                          title: Text('정보를 입력해야 넘어갈 수 있습니다'),
                        );
                      },
                    );
                  }
                },
                child: SizedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('문항보기 ',
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
            ],
          ),
        ),
      ),
    );
  }
}
