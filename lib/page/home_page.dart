import 'package:flutter/material.dart';
import 'package:pillyze_copy/page/3D/AI_3D_posture.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;
import 'package:pillyze_copy/main.dart';
import 'package:pillyze_copy/page/recommend/AI_recommend.dart';

Future<void> signOut() async {
  try {
    await kakao.UserApi.instance.logout();
    print("카카오 로그아웃 성공");
  } catch (error) {
    print("Error signing out: $error");
  }
}

class home_page extends StatefulWidget {
  const home_page({super.key});

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
        return const AI_recommend();
      case 1:
        return const AI_3D_posture();
    }
    return null;
  }

  Widget _bottomWidget() {
    return BottomNavigationBar(
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        // Color(0xff1e2c5b)
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
        items: const [
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.home_rounded,
                  color: Colors.indigo,
                )),
            label: '운동 보조식품',
            activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(Icons.home_rounded, color: Colors.indigo)),
          ),
          BottomNavigationBarItem(
            icon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(
                  Icons.shopping_cart,
                  color: Colors.indigo,
                )),
            label: '운동 자세',
            activeIcon: Padding(
                padding: EdgeInsets.only(bottom: 5),
                child: Icon(Icons.shopping_cart, color: Colors.indigo)),
          ),
        ]);
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
                  await signOut();
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