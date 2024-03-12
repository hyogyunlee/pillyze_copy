import 'package:flutter/material.dart';
import 'package:pillyze_copy/components/q1.dart';
import 'package:pillyze_copy/components/q2.dart';
import 'package:pillyze_copy/components/q3.dart';
import 'package:pillyze_copy/components/q4.dart';
import 'package:pillyze_copy/data.dart';
import 'package:pillyze_copy/page/survey/mobile/info_page_mobile2.dart';

class InfoPage extends StatefulWidget {
  const InfoPage({super.key});

  @override
  State<InfoPage> createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
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
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(bottom: 12.0),
                child: Text(
                  '당신은 어떤 사람인가요?',
                  style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width/2,
                          height: 250,
                          child: Q1()),
                      SizedBox(
                          width: MediaQuery.of(context).size.width/2,
                          height: 250,
                          child: Q2()),
                    ],
                  ),
                  Column(
                    children: [
                      SizedBox(
                          width: MediaQuery.of(context).size.width/2,
                          height: 250,
                          child: Q3()),
                      SizedBox(
                          width: MediaQuery.of(context).size.width/2,
                          height: 250,
                          child: Q4()),
                    ],
                  ),
                ],
              ),
              SizedBox(height:50),
              InkWell(
                onTap: () {
                  if (Data.staticQ1 == true &&
                      Data.staticQ2 == true &&
                      Data.staticQ3 == true &&
                      Data.staticQ4 == true) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => InfoPage2(),
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
                      Text('다음 질문',
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
