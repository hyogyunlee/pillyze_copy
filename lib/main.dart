import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;
import 'package:pillyze_copy/component/kakao_button.dart';
import 'package:pillyze_copy/account/kakao_main_view_model.dart';
import 'package:pillyze_copy/account/kakao_login.dart';
import 'package:pillyze_copy/page/home_page.dart';
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
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>home_page(loginMethod: 'kakaoLogin'),
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
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Image.asset('assets/maida.png'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80.0, vertical: 10),
                    child: kakaoButton(
                      ontap: () async {
                        if (!kakaoviewModel.isLogined) {
                          await kakaoviewModel.login();
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => home_page(loginMethod: 'kakaoLogin'),
                            ),
                          );
                        }
                      },
                      text: '카카오톡으로 로그인',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 80.0, vertical: 10),
                    child: ElevatedButton(
                      onPressed: (){
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => home_page(loginMethod: 'freeTest'),
                          ),
                        );
                      },
                      child:Text('서비스 둘러보기',),
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