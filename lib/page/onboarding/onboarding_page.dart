import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk_user.dart' as kakao;
import 'package:lottie/lottie.dart';
import 'package:pillyze_copy/page/home_page.dart';
import 'package:pillyze_copy/component/textfield.dart';
import 'package:pillyze_copy/page/onboarding/agree.dart';

enum HealthStatus { none, breastfeeding, pregnant, planning }
enum SmokeStatus {smoke, nonsmoke}
enum DiseaseStatus {no, yes}
enum AllergyStatus {no, yes}
enum DrugStatus {no, yes}

Future<String> _generateToken() async {
  var rng = new Random();
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  String token;

  // Firestore에서 'users' 컬렉션을 조회하여 토큰들을 가져옵니다.
  var snapshot = await firestore.collection('users').get();
  var existingTokens = snapshot.docs.map((doc) => doc.id).toList();

  do {
    token = rng.nextInt(1000000).toString(); // 랜덤 토큰 생성
  } while (existingTokens.contains(token)); // 이미 존재하는 토큰들 중에 없을 때까지 반복

  print("Generated Token: $token");

  return token;
}

class onboarding_page extends StatefulWidget {
  final String loginMethod;
  const onboarding_page({Key? key, required this.loginMethod}) : super(key: key);
  @override
  State<onboarding_page> createState() => _onboarding_pageState();
}

class _onboarding_pageState extends State<onboarding_page> {
  late final PageController _pageController;
  int _currentPageIndex = 0;
  DateTime _dateTime = DateTime.now();
  late DateTime date;

  String user='';
  kakao.User? kakao_user;
  final currentUser = FirebaseAuth.instance.currentUser;

  bool femaleSelect = false;
  bool maleSelect = false;
  bool allCheck = false;
  bool Check1 = false;
  bool Check2 = false;
  bool Check3 = false;
  bool Check4 = false;

  final nameEditingController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final TextEditingController _monthController = TextEditingController();
  final TextEditingController _dayController = TextEditingController();
  bool isButtonEnabled = false;
  bool get isButtonOver2 => healthConcernsSelectedItems.where((bool item) => item == true).length >= 2;

  HealthStatus? _selectedHealthStatus;
  SmokeStatus? _selectedSmokeStatus;
  DiseaseStatus? _selectedDiseaseStatus;
  AllergyStatus? _selectedAllergyStatus;
  DrugStatus? _selectedDrugStatus;

  List<String> healthConcerns = ['눈건강', '피로감', '장건강', '피부건강', '빈혈', '노화&향산화',];
  List<Icon> healthIcon = [const Icon(Icons.remove_red_eye_rounded, size:80), const Icon(Icons.energy_savings_leaf_rounded, size:80), const Icon(Icons.energy_savings_leaf_rounded, size:80), const Icon(Icons.energy_savings_leaf_rounded, size:80), const Icon(Icons.bloodtype_rounded, size:80), const Icon(Icons.timer_rounded, size:80)];
  List<bool> healthConcernsSelectedItems = List.generate(6, (index) => false);

  // 기저질환 항목들을 나타내는 리스트
  List<String> diseaseItems = ['간질환', '신장질환', '당뇨', '고혈압', '고지혈증(콜레스테롤 높음)', '빈혈', '과체중/비만', '위장질환', '갑상선질환'];
  List<bool> diseaseSelectedItems = List.generate(9, (index) => false);
  List<bool> isDiseaseSelected = []; // 질환들의 선택 여부를 추적하는 리스트

  List<String> drugItems = ['혈압약', '당뇨약', '고지혈증약', '위장약', '변비약', '소화제', '항생제', '소염진통제', '항히스타민제'];
  List<bool> drugSelectedItems = List.generate(9, (index) => false);
  List<bool> isDrugSelected = [];

  List<String> selectedHealthConcerns = [];
  List<String> selectedDiseaseItems = [];
  List<String> selectedDrugItems = [];

  // 유저 정보 업데이트
  void FirestoreUpload() async {
    for (int i = 0; i < healthConcernsSelectedItems.length; i++) {
      if (healthConcernsSelectedItems[i]) {
        selectedHealthConcerns.add(healthConcerns[i]);
      }
    }
    for (int i = 0; i < diseaseSelectedItems.length; i++) {
      if (diseaseSelectedItems[i]) {
        selectedDiseaseItems.add(diseaseItems[i]);
      }
    }
    for (int i = 0; i < drugSelectedItems.length; i++) {
      if (drugSelectedItems[i]) {
        selectedDrugItems.add(drugItems[i]);
      }
    }

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    //로그인 확인
    bool isKakaoLoggedIn = false;

    try {
      await kakao.UserApi.instance.accessTokenInfo();
      isKakaoLoggedIn = true;
    } catch (e) {
      isKakaoLoggedIn = false;
    }

    if (widget.loginMethod == 'freeTest') {
      String basic_user = await _generateToken();
      user = basic_user;
    }
    else{
      kakao_user = await kakao.UserApi.instance.me();
      user = kakao_user!.id.toString();
    }
    Map<String, dynamic> userData = {
      'gender': maleSelect ? 'male' : 'female',
      'nickname': nameEditingController.text,
      'birthday': date,
      'health_concerns':selectedHealthConcerns,
      'health_status':_selectedHealthStatus.toString().split('.').last,
      'smoke_status':_selectedSmokeStatus.toString().split('.').last,
      'disease_status':_selectedDiseaseStatus.toString().split('.').last,
      'allergy_status':_selectedAllergyStatus.toString().split('.').last,
      'drug_status':_selectedDrugStatus.toString().split('.').last,
      //'email':user!.kakaoAccount!.email ?? '',
      'photoURL':kakao_user?.kakaoAccount!.profile!.profileImageUrl!,
      'marketing_agree':Check4,
      'notification':false,
    };
    if(int.parse(_monthController.text)<=_dateTime.month && int.parse(_dayController.text)<=_dateTime.day){
      userData['age'] = _dateTime.year-int.parse(_yearController.text);
    }
    else{
      userData['age'] = _dateTime.year-int.parse(_yearController.text)-1;
    }

    if (_selectedDiseaseStatus == DiseaseStatus.yes) {
      userData['disease'] = selectedDiseaseItems;
    }

    if(_selectedDrugStatus==DrugStatus.yes){
      userData['drug'] = selectedDrugItems;
    }

    await firestore.collection('users').doc(user).set(userData, SetOptions(merge: true));
  }

  void nextPage() {
    if (_currentPageIndex < 10) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceInOut,
      );
      setState(() {
        _currentPageIndex++;
      });
    }
  }

  void previousPage() {
    if (_currentPageIndex > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.bounceInOut,
      );
      setState(() {
        _currentPageIndex--;
      });
    }
  }

  void onDateTimeChanged(dateTime) {
    setState(() {
      _dateTime = dateTime;
    });
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _yearController.addListener(updateButtonState);
    _monthController.addListener(updateButtonState);
    _dayController.addListener(updateButtonState);
    isDiseaseSelected = List<bool>.filled(diseaseItems.length, false);
    isDrugSelected = List<bool>.filled(drugItems.length, false);
  }

  updateButtonState() {
    setState(() {
      isButtonEnabled = isDate(_yearController.text, _monthController.text, _dayController.text);
    });
  }

  bool isDate(String year, String month, String day) {
    try {
      date = DateTime(int.parse(year), int.parse(month), int.parse(day));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    nowpage() {
      return Padding(
        padding: const EdgeInsets.only(right: 15.0),
        child: Text(
          _currentPageIndex.toString(),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );
    }

    nextButton(String txt) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
          child: ElevatedButton(
              onPressed: () {
                nextPage();
              },
              style: ElevatedButton.styleFrom(
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  fixedSize: Size(width, 50),
                  backgroundColor: Colors.black),
              child: Text(
                txt,
                style: const TextStyle(fontSize: 18),
              )),
        ),
      );
    }

    deadButton(String txt) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 20),
          child: Container(
            width: width,
            height: 50,
            decoration: BoxDecoration(
                color: Colors.grey, borderRadius: BorderRadius.circular(25)),
            child: Center(
              child: Text(
                txt,
                style: TextStyle(fontSize: 18, color: Colors.grey[200]),
              ),
            ),
          ),
        ),
      );
    }

    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: PageView(
            physics: const NeverScrollableScrollPhysics(),
            controller: _pageController,
            onPageChanged: (int index) {
              setState(() {
                _currentPageIndex = index;
              });
            },
            children: [
              //가입 동의
              Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const BackButton(
                          style: ButtonStyle(),
                        ),
                        nowpage()
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(23, 20, 25, 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: Text(
                                '약관에 동의해주세요',
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w600),
                              ),
                            ),
                            const Text(
                              '여러분의 개인정보와 서비스 이용 권리 \n잘 지켜드릴게요',
                              style: TextStyle(
                                fontSize: 15, color: Colors.grey,
                              )
                            ),
                            Column(
                              children: [
                                Row(
                                  children: [
                                    Checkbox(
                                      activeColor: Colors.black,
                                      checkColor: Colors.white,
                                      shape: const CircleBorder(),
                                      value: allCheck,
                                      onChanged: (value) {
                                        setState(() {
                                          allCheck = value!;
                                          Check1 = value;
                                          Check2 = value;
                                          Check3 = value;
                                          Check4 = value;
                                        });
                                      },
                                    ),
                                    const Text(
                                      '모두 동의',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w600, fontSize: 18),
                                    ),
                                  ],
                                ),
                                const Text(
                                  '서비스 이용을 위해 아래 약관에 모두 동의합니다.',
                                  style: TextStyle(
                                      fontSize: 13, color:Colors.grey),
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          activeColor: Colors.black,
                                          checkColor: Colors.white,
                                          shape: const CircleBorder(),
                                          value: Check1,
                                          onChanged: (value) {
                                            setState(() {
                                              Check1 = value!;
                                            });
                                          },
                                        ),
                                        const Text(
                                          '(필수) 만 14세 이상입니다.',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => const Agree(),
                                              ));
                                        },
                                        child: const Text(
                                          '보기',
                                          style: TextStyle(color: Colors.grey),
                                        ))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          activeColor: Colors.black,
                                          checkColor: Colors.white,
                                          shape: const CircleBorder(),
                                          value: Check2,
                                          onChanged: (value) {
                                            setState(() {
                                              Check2 = value!;
                                            });
                                          },
                                        ),
                                        const Text(
                                          '(필수) 서비스 이용약관 동의',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                        onTap: () {},
                                        child: const Text(
                                          '보기',
                                          style: TextStyle(color: Colors.grey),
                                        ))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          activeColor: Colors.black,
                                          checkColor: Colors.white,
                                          shape: const CircleBorder(),
                                          value: Check3,
                                          onChanged: (value) {
                                            setState(() {
                                              Check3 = value!;
                                            });
                                          },
                                        ),
                                        const Text(
                                          '(필수) 개인정보 처리방침 이용동의',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                        onTap: () {},
                                        child: const Text(
                                          '보기',
                                          style: TextStyle(color: Colors.grey),
                                        ))
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          activeColor: Colors.black,
                                          checkColor: Colors.white,
                                          shape: const CircleBorder(),
                                          value: Check4,
                                          onChanged: (value) {
                                            setState(() {
                                              Check4 = value!;
                                            });
                                          },
                                        ),
                                        const Text(
                                          '(선택) 마케팅 수신 동의',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    GestureDetector(
                                        onTap: () {},
                                        child: const Text(
                                          '보기',
                                          style: TextStyle(color: Colors.grey),
                                        ))
                                  ],
                                ),
                              ],
                            ),
                            Check1 && Check2 && Check3 == true
                                ? nextButton('가입완료')
                                : deadButton('가입완료')
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              //온보딩1
              Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButton(
                          style: const ButtonStyle(),
                          onPressed: previousPage,
                        ),
                        nowpage()
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text(
                                  '가입을 축하드려요! \n어떻게 불러드리면 될까요?',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Column(
                                children: [
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Mytextfield(
                                      text:'',
                                      hintText: '5글자 내로 입력해주세요',
                                      textEditingController:
                                      nameEditingController),
                                  const SizedBox(
                                    height: 200,
                                  ),
                                ],
                              ),
                            ],
                          ),
                      ),
                    )
                  ],
                ),
                (nameEditingController.text.isNotEmpty)
                    ? nextButton('다음')
                    : deadButton('다음')
              ]),
              //온보딩2
              Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButton(
                          style: const ButtonStyle(),
                          onPressed: previousPage,
                        ),
                        nowpage()
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 20.0),
                                child: Text(
                                  '${nameEditingController.text}님의 생일을 \n알려주세요.',
                                  style: const TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Text(
                                '만 나이를 기준으로 \n건강 분석이 진행돼요',
                                style: TextStyle(
                                    fontSize: 15,
                                    color:Colors.grey),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 20, bottom: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _yearController,
                                        decoration: const InputDecoration(
                                          hintText: 'yyyy',
                                        ),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const Text(
                                      '/',
                                      style:TextStyle(
                                          fontSize:15,
                                          color:Colors.grey),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _monthController,
                                        decoration: const InputDecoration(
                                          hintText: 'MM',
                                        ),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const Text(
                                      '/',
                                      style:TextStyle(
                                          fontSize:15,
                                          color:Colors.grey),
                                    ),
                                    Expanded(
                                      child: TextField(
                                        controller: _dayController,
                                        decoration: const InputDecoration(
                                          hintText: 'dd',
                                        ),
                                        keyboardType: TextInputType.number,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                      ),
                    )
                  ],
                ),
                (isButtonEnabled)
                    ? nextButton('다음')
                    : deadButton('다음')
              ]
              ),
              //온보딩3
              Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          BackButton(
                            style: const ButtonStyle(),
                            onPressed: previousPage,
                          ),
                          nowpage()
                        ],
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(top: 20.0),
                                  child: Text(
                                    '성별은 \n어떻게 되시나요?',
                                    style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                                const Text(
                                  '성별에 따라 필요한 영양성분이 \n다를 수 있어요.',
                                  style: TextStyle(
                                      fontSize: 15,
                                      color:Colors.grey),
                                ),
                                Column(
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              maleSelect = !maleSelect;
                                              maleSelect == true
                                                  ? femaleSelect = false
                                                  : femaleSelect = true;
                                            });
                                            nextPage();
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: maleSelect
                                                ? Colors.indigo[900]
                                                : Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                BorderRadius.circular(20.0)),
                                          ),
                                          child: const Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                  width: 100,
                                                  height: 100,
                                                  child: Icon(Icons.male)),
                                              Text('남성'),
                                            ],
                                          ),
                                        ),
                                        OutlinedButton(
                                          onPressed: () {
                                            setState(() {
                                              femaleSelect = !femaleSelect;
                                              femaleSelect == true
                                                  ? maleSelect = false
                                                  : maleSelect = true;
                                            });
                                            nextPage();
                                          },
                                          style: OutlinedButton.styleFrom(
                                            backgroundColor: femaleSelect
                                                ? Colors.pink
                                                : Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 5),
                                            shape: RoundedRectangleBorder(
                                                side: const BorderSide(
                                                    color: Colors.white),
                                                borderRadius:
                                                BorderRadius.circular(20.0)),
                                          ),
                                          child: const Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              SizedBox(
                                                  width: 100,
                                                  height: 100,
                                                  child: Icon(Icons.female)),
                                              Text('여성'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ),
                      )
                    ],
                  ),
                ]
              ),
              //온보딩4
              Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButton(
                          style: const ButtonStyle(),
                          onPressed: previousPage,
                        ),
                        nowpage()
                      ],
                    ),
                    Expanded(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children:[
                                      const Padding(
                                        padding: EdgeInsets.only(top: 20.0),
                                        child: Text(
                                          '고민되시거나 개선하고 싶은 \n건강고민을 선택해주세요',
                                          style: TextStyle(
                                              fontSize: 24,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      SizedBox(height: 15.0,),
                                      const Text(
                                        '최소 2개 선택',
                                        style: TextStyle(
                                            fontSize: 15,
                                            color:Colors.grey),
                                      ),
                                    ]
                                ),
                                SizedBox(height: 15.0,),
                                Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children:[
                                      Align(
                                          alignment: Alignment.topCenter,
                                          child: Wrap(
                                            spacing: 15.0, // 각 항목 사이의 가로 간격
                                            runSpacing: 40.0, // 각 줄 사이의 세로 간격
                                            children: healthConcerns.asMap().entries.map<Widget>((entry) {
                                              int index = entry.key;
                                              String itemName = entry.value;
                                              return OutlinedButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      healthConcernsSelectedItems[index] = !healthConcernsSelectedItems[index];
                                                    });
                                                  },
                                                  style: OutlinedButton.styleFrom(
                                                    backgroundColor: healthConcernsSelectedItems[index]
                                                        ? Colors.blue
                                                        : Colors.white,
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 5, vertical: 5),
                                                    shape: RoundedRectangleBorder(
                                                        side: const BorderSide(
                                                            color: Colors.white),
                                                        borderRadius:
                                                        BorderRadius.circular(20.0)),
                                                  ),
                                                  child: Column(
                                                    children: <Widget>[
                                                      healthIcon[index],
                                                      Text(itemName),
                                                    ],
                                                  )
                                              );
                                            }).toList(),
                                          ),
                                      ),
                                    ]
                                ),
                              ]
                          ),
                        )
                    ),
                    (isButtonOver2)
                        ? nextButton('확인 (${healthConcernsSelectedItems.where((bool item) => item == true).length}/6)')
                        : deadButton('확인 (${healthConcernsSelectedItems.where((bool item) => item == true).length}/6)')
                  ],
                ),
              ]),
              //온보딩5
              Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButton(
                          style: const ButtonStyle(),
                          onPressed: previousPage,
                        ),
                        nowpage()
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text(
                                  '아래 해당하는 상태가 있다면 \n선택해주세요',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(height: 15.0,),
                              const Text(
                                '임신 중이시거나 수유 중이시면 \n더 신경써서 알려드릴게요.',
                                style: TextStyle(
                                    fontSize: 15,
                                    color:Colors.grey),
                              ),
                              SizedBox(height: 15.0,),
                              // RadioButton Group 추가 부분
                              Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(15), // 박스 세로 크기 변경
                                  title: const Text('해당사항 없음'),
                                  trailing: Radio(
                                    value: HealthStatus.none,
                                    groupValue: _selectedHealthStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedHealthStatus = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(15), // 박스 세로 크기 변경
                                  title: const Text('수유 중'),
                                  trailing: Radio(
                                    value: HealthStatus.breastfeeding,
                                    groupValue: _selectedHealthStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedHealthStatus = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(15), // 박스 세로 크기 변경
                                  title: const Text('임신 중'),
                                  trailing: Radio(
                                    value: HealthStatus.pregnant,
                                    groupValue: _selectedHealthStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedHealthStatus = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(15), // 박스 세로 크기 변경
                                  title: const Text('6개월 내에 자녀계획 있음'),
                                  trailing: Radio(
                                    value: HealthStatus.planning,
                                    groupValue: _selectedHealthStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedHealthStatus = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
                    (_selectedHealthStatus!=null)
                        ? nextButton('다음')
                        : deadButton('다음')
                  ],
                ),
              ]),
              //온보딩6
              Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButton(
                          style: const ButtonStyle(),
                          onPressed: previousPage,
                        ),
                        nowpage()
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text(
                                  '흡연 여부에 대해 \n알려주세요',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(height: 15.0,),
                              const Text(
                                '흡연을 하시는 경우 조심해야 할 \n영양 성분이 있어요',
                                style: TextStyle(
                                    fontSize: 15,
                                    color:Colors.grey),
                              ),
                              SizedBox(height: 15.0,),
                              // RadioButton Group 추가 부분
                              Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(15), // 박스 세로 크기 변경
                                  title: const Text('비흡연'),
                                  trailing: Radio(
                                    value: SmokeStatus.nonsmoke,
                                    groupValue: _selectedSmokeStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSmokeStatus = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(15), // 박스 세로 크기 변경
                                  title: const Text('흡연'),
                                  trailing: Radio(
                                    value: SmokeStatus.smoke,
                                    groupValue: _selectedSmokeStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedSmokeStatus = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
                    (_selectedSmokeStatus!=null)
                      ? nextButton('다음')
                      : deadButton('다음')
                  ],
                ),
              ]),
              //온보딩7
              Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButton(
                          style: const ButtonStyle(),
                          onPressed: previousPage,
                        ),
                        nowpage()
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text(
                                  '갖고있는 질환이 있다면 \n선택해주세요',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(height: 15.0,),
                              const Text(
                                '각 상태에서 피해야 하는 영양성분을 \n분석해드릴게요',
                                style: TextStyle(
                                    fontSize: 15,
                                    color:Colors.grey),
                              ),
                              SizedBox(height: 15.0,),
                              // RadioButton Group 추가 부분
                              Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(15), // 박스 세로 크기 변경
                                  title: const Text('기저질환이 없어요'),
                                  trailing: Radio(
                                    value: DiseaseStatus.no,
                                    groupValue: _selectedDiseaseStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedDiseaseStatus = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(15), // 박스 세로 크기 변경
                                  title: const Text('기저질환이 있어요'),
                                  trailing: Radio(
                                    value: DiseaseStatus.yes,
                                    groupValue: _selectedDiseaseStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedDiseaseStatus = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              // 기저질환이 있어요를 선택했을 때만 보이는 리스트
                              if (_selectedDiseaseStatus == DiseaseStatus.yes) ...[
                                SizedBox(height: 15.0,),
                                Center(
                                  child:Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8.0, // 각 항목 사이의 가로 간격
                                    runSpacing: 4.0, // 각 줄 사이의 세로 간격
                                    children: <Widget>[...diseaseItems.asMap().entries.map<Widget>((entry) {
                                      int index = entry.key;
                                      String itemName = entry.value;
                                      return OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            diseaseSelectedItems[index] = !diseaseSelectedItems[index];
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: diseaseSelectedItems[index]
                                              ? Colors.blue
                                              : Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.white),
                                              borderRadius:
                                              BorderRadius.circular(20.0)),
                                        ),
                                        child: Text(itemName),
                                      );
                                    }).toList()],
                                  ),
                                ),
                              ],
                            ],
                          ),
                      ),
                    ),
                    (_selectedDiseaseStatus == DiseaseStatus.yes)
                        ? (_selectedDiseaseStatus!=null)
                        ? nextButton('다음 (${diseaseSelectedItems.where((bool item) => item == true).length}개)')
                        : deadButton('다음 (${diseaseSelectedItems.where((bool item) => item == true).length}개)')
                        : (_selectedDiseaseStatus!=null)
                        ? nextButton('다음')
                        : deadButton('다음')
                  ],
                ),
              ]),
              //온보딩8
              Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButton(
                          style: const ButtonStyle(),
                          onPressed: previousPage,
                        ),
                        nowpage()
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text(
                                  '알러지가 있으신가요?',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(height: 15.0,),
                              const Text(
                                '각 상태에서 피해야 하는 영양성분을 \n분석해드릴게요',
                                style: TextStyle(
                                    fontSize: 15,
                                    color:Colors.grey),
                              ),
                              SizedBox(height: 15.0,),
                              // RadioButton Group 추가 부분
                              Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(15), // 박스 세로 크기 변경
                                  title: const Text('알러지가 없어요'),
                                  trailing: Radio(
                                    value: AllergyStatus.no,
                                    groupValue: _selectedAllergyStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedAllergyStatus = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(15), // 박스 세로 크기 변경
                                  title: const Text('알러지가 있어요'),
                                  trailing: Radio(
                                    value: AllergyStatus.yes,
                                    groupValue: _selectedAllergyStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedAllergyStatus = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                      ),
                    ),
                    (_selectedAllergyStatus!=null)
                        ? nextButton('다음')
                        : deadButton('다음')
                  ],
                ),
              ]),
              //온보딩9
              Stack(children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        BackButton(
                          style: const ButtonStyle(),
                          onPressed: previousPage,
                        ),
                        nowpage()
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 10, 15, 20),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 20.0),
                                child: Text(
                                  '복용 중인 약이 있으신가요?',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              SizedBox(height: 15.0,),
                              const Text(
                                '함께 먹으면 안되는 영양성분을 분석해드릴게요',
                                style: TextStyle(
                                    fontSize: 15,
                                    color:Colors.grey),
                              ),
                              SizedBox(height: 15.0,),
                              // RadioButton Group 추가 부분
                              Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(15), // 박스 세로 크기 변경
                                  title: const Text('복용 중인 약이 없어요'),
                                  trailing: Radio(
                                    value: DrugStatus.no,
                                    groupValue: _selectedDrugStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedDrugStatus = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              Card(
                                child: ListTile(
                                  contentPadding: EdgeInsets.all(15), // 박스 세로 크기 변경
                                  title: const Text('복용 중인 약이 없어요'),
                                  trailing: Radio(
                                    value: DrugStatus.yes,
                                    groupValue: _selectedDrugStatus,
                                    onChanged: (value) {
                                      setState(() {
                                        _selectedDrugStatus = value;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              // 복용중인 약이 있어요를 선택했을 때만 보이는 리스트
                              if (_selectedDrugStatus == DrugStatus.yes) ...[
                                SizedBox(height: 15.0,),
                                Center(
                                  child:Wrap(
                                    alignment: WrapAlignment.center,
                                    spacing: 8.0, // 각 항목 사이의 가로 간격
                                    runSpacing: 4.0, // 각 줄 사이의 세로 간격
                                    children: drugItems.asMap().entries.map<Widget>((entry) {
                                      int index = entry.key;
                                      String itemName = entry.value;
                                      return OutlinedButton(
                                        onPressed: () {
                                          setState(() {
                                            drugSelectedItems[index] = !drugSelectedItems[index];
                                          });
                                        },
                                        style: OutlinedButton.styleFrom(
                                          backgroundColor: drugSelectedItems[index]
                                              ? Colors.blue
                                              : Colors.white,
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 5),
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  color: Colors.white),
                                              borderRadius:
                                              BorderRadius.circular(20.0)),
                                        ),
                                        child: Text(itemName),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ],
                          ),
                      ),
                    ),
                    (_selectedDrugStatus == DrugStatus.yes)
                        ? (_selectedDrugStatus!=null)
                        ? nextButton('다음 (${drugSelectedItems.where((bool item) => item == true).length}개)')
                        : deadButton('다음 (${drugSelectedItems.where((bool item) => item == true).length}개)')
                        : (_selectedDrugStatus!=null)
                        ? nextButton('다음')
                        : deadButton('다음')
                  ],
                ),
              ]),
              //온보딩10
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 80.0),
                      child: Text(
                        '${nameEditingController.text}님이 입력하신 정보를 분석해 \n 보충제 포트폴리오를 추천해드리겠습니다',
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50.0),
                      child: LottieBuilder.asset('assets/loading.json'),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ElevatedButton(
                          onPressed: (){
                            try {
                              FirestoreUpload();
                              print('Firestore data updated successfully');
                            } catch (error) {
                              print('Error updating Firestore data: $error');
                            }
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => home_page(loginMethod:widget.loginMethod),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              fixedSize: Size(width, 50),
                              backgroundColor: Colors.black),
                          child: const Text(
                            '일단 넘어가기',
                            style: TextStyle(fontSize: 18),
                          )
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}