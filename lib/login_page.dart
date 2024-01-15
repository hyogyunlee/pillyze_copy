import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;
import 'package:pillyze_copy/kakao_button.dart';
import 'package:pillyze_copy/kakao_main_view_model.dart';
import 'package:pillyze_copy/kakao_login.dart';
import 'package:pillyze_copy/onboarding_page.dart';
import 'package:pillyze_copy/next.dart';

Future<DocumentSnapshot?> fetchUserInfo(String? uid) async {
  try {
    final firestore = FirebaseFirestore.instance;
    final documentSnapshot = await firestore.collection('users').doc(uid).get();
    if (documentSnapshot.exists) {
      return documentSnapshot;
    }
  } catch (e) {
    print('Error fetching user info from Firestore: $e');
  }
  return null;
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final kakaoviewModel = kakao_MainViewModel(KakaoLogin());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: Colors.white,
          body: Center(
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80.0, vertical: 10),
                        child: kakaoButton(
                            ontap: () async {
                              await kakaoviewModel.login();
                              kakao.User? user= await kakao.UserApi.instance.me();
                              final userInfo = await fetchUserInfo(user.id.toString());
                              final hasEmptyFields = userInfo == null;
                              if (kakaoviewModel.isLogined) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => hasEmptyFields ? const OnBoardingPage() : const next(),
                                  ),
                                );
                              }
                              setState(() {});
                            },
                            text: '카카오톡으로 로그인')
                    ),
                  ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}