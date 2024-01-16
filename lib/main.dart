import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;
import 'package:pillyze_copy/kakao_button.dart';
import 'package:pillyze_copy/kakao_main_view_model.dart';
import 'package:pillyze_copy/kakao_login.dart';
import 'package:pillyze_copy/onboarding_page.dart';
import 'package:pillyze_copy/next.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pillyze_copy/firebase_options.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';

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

Future<bool> isSignedInKakao() async {
  try {
    await kakao.UserApi.instance.accessTokenInfo();
    return true;
  } catch (e) {
    return false;
  }
}

void main() async{
  KakaoSdk.init(nativeAppKey: '5923bfe08d5e8f3ce5e231bb228b7907');
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final kakaoviewModel = kakao_MainViewModel(KakaoLogin());

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  void checkLoginStatus() async {
    bool isKakaoLoggedIn = await isSignedInKakao();
    if (isKakaoLoggedIn) {
      kakao.User? user = await kakao.UserApi.instance.me();
      final userInfo = await fetchUserInfo(user.id.toString());
      final hasEmptyFields = userInfo == null;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => hasEmptyFields ? const OnBoardingPage() : const next(),
        ),
      );
    }
  }

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
                        if (!kakaoviewModel.isLogined) {
                          await kakaoviewModel.login();
                          kakao.User? user = await kakao.UserApi.instance.me();
                          final userInfo = await fetchUserInfo(user.id.toString());
                          final hasEmptyFields = userInfo == null;
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => hasEmptyFields ? const OnBoardingPage() : const next(),
                            ),
                          );
                        }
                      },
                      text: '카카오톡으로 로그인',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}