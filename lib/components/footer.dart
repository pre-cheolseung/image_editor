import 'package:flutter/material.dart';

typedef OnEmoticonTap = void Function(int id);   // 스티커를 선택할 때마다 실행할 함수의 시그니처

class Footer extends StatelessWidget {
  final OnEmoticonTap onEmoticonTap;

  // const 생성자 : 최초 선언 후 변경 불가능한 빌드 타임 함수
  const Footer({
    required this.onEmoticonTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.white.withValues(alpha: 0.9),
      height: 150,
      // 가로로 스크롤이 가능하게 구현
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(
            7,
            (index) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: GestureDetector(
                onTap: () {
                  onEmoticonTap(index + 1);   // 스티커를 선택할 때 실행할 함수
                },
                child: Image.asset(
                  'assets/img/emoticon_${index + 1}.png',
                  height: 100,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}