import 'package:flutter/material.dart';

class kakaoButton extends StatelessWidget {
  final Function ontap;
  final String text;
  const kakaoButton({super.key, required this.ontap, required this.text});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => ontap(),
      child: Container(
          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Colors.yellowAccent[400]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/kakao.png',
                scale: 16,
              ),
              Text(
                text,
                style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
              )
            ],
          )),
    );
  }
}