import 'package:flutter/material.dart';
import 'package:pillyze_copy/login_page.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;
import 'package:pillyze_copy/main.dart';

Future<void> signOut() async {
  try {
    await kakao.UserApi.instance.logout();
    print("카카오 로그아웃 성공");
  } catch (error) {
    print("Error signing out: $error");
  }
}

class next extends StatefulWidget {
  const next({super.key});

  @override
  State<next> createState() => _HomePageState();
}

class _HomePageState extends State<next> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          await signOut();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MyHomePage(),
            ),
          );
        },
        child: Row(
          children: [
            Icon(Icons.logout_rounded),
            Text("로그아웃"),
          ],
        ),
      ),
    );
  }
}