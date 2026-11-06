// gal: ^2.3.3

// import 'package:gal/gal.dart';

// try {
//   // 100% 화질(원본 바이트) 그대로 갤러리에 저장
//   await Gal.putImageBytes(pngByte);
//   print('갤러리에 이미지가 성공적으로 저장되었습니다.');
// } on GalException catch (e) {
//   // 권한 부족, 용량 부족 등 에러 처리
//   print('저장 실패: ${e.type.name}');
// } catch (e) {
//   print('알 수 없는 오류 발생: $e');
// }

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);   // const 생성자 : 최초 선언 후 변경 불가능한 빌드 타임 함수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('Home Screen'),
    );
  }
}