import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;
import 'package:pillyze_copy/main.dart';
import 'package:pillyze_copy/page/ai_pose/healthSelect.dart';
import 'package:pillyze_copy/page/survey/AI_recommend.dart';

Future<void> signOut() async {
  try {
    await kakao.UserApi.instance.logout();
    print("카카오 로그아웃 성공");
  } catch (error) {
    print("Error signing out: $error");
  }
}

class home_page extends StatefulWidget {
  final String loginMethod;
  const home_page({super.key, required this.loginMethod});

  @override
  State<home_page> createState() => _HomePageState();
}

class _HomePageState extends State<home_page> {
  late int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = 0;
  }

  Widget? _bodyWidget() {
    switch (_currentPageIndex) {
      case 0:
        return AI_recommend(loginMethod: widget.loginMethod);
      case 1:
        return const Select();
    }
    return null;
  }

  Widget _bottomWidget() {
    List<BottomNavigationBarItem> items = [
      const BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(
            Icons.home_rounded,
            color: Colors.indigo,
          ),
        ),
        label: '운동 보조식품',
        activeIcon: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(Icons.home_rounded, color: Colors.indigo),
        ),
      ),
      BottomNavigationBarItem(
        icon: Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Icon(
            Icons.shopping_cart,
            color: Colors.indigo,
          ),
        ),
        label: '운동 자세',
      ),
    ];

    return BottomNavigationBar(
      elevation: 0,
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      onTap: (int index) {
        setState(() {
          _currentPageIndex = index;
        });
      },
      currentIndex: _currentPageIndex,
      unselectedItemColor: Colors.indigo,
      selectedItemColor: Colors.indigo,
      selectedFontSize: 20,
      unselectedLabelStyle:
      const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
      selectedLabelStyle:
      const TextStyle(fontWeight: FontWeight.w600, color: Colors.blue),
      items: items,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:Scaffold(
          appBar: AppBar(
            title: Text("MAIDA", style:TextStyle(fontSize:25.0)),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  if(widget.loginMethod=='kakaoLogin') {
                    await signOut();
                  }
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MyHomePage(),
                    ),
                  );
                },
                child: Icon(Icons.logout_rounded),
              ),
            ],
          ),
          body: _bodyWidget(),
          bottomNavigationBar: _bottomWidget(),
        )
    );
  }
}
