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

import 'package:image_editor/components/main_app_bar.dart';
import 'package:image_editor/components/footer.dart';

import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);   // const 생성자 : 최초 선언 후 변경 불가능한 빌드 타임 함수

  @override
  // State<HomeScreen> createState() => _HomeScreenState();
  State<HomeScreen> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  XFile? image;   // 선택한 이미지를 저장할 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 스크린에 Body, AppBar, Footer 순서로 쌓을 준비
      body: Stack(
        fit: StackFit.expand,   // 자식 위젯들을 최대 크기로 확대
        children: [
          // MainAppBar를 상단, 좌, 우, 끝에 정렬
          Positioned(
            top: 0,
            // left와 right 모두 0을 주면 좌우로 최대 크기 차지
            left: 0,
            right: 0,
            child: MainAppBar(
              onPickImage: onPickImage,   // 이미지 선택 버튼
              onDeleteImage: onDeleteImage,   // 이미지 삭제 버튼
              onSaveImage: onSaveImage,   // 이미지 저장 버튼
            ),
          ),
          // 이미지가 선택되면 Footer 위치
          if (image != null)
            // Footer를 하단, 좌, 우, 끝에 정렬
            Positioned(
              bottom: 0,
              // left와 right 모두 0을 주면 좌우로 최대 크기 차지
              left: 0,
              right: 0,
              child: Footer(
                onEmoticonTap: onEmoticonTap,
              ),
            ),
        ],
      ),
    );
  }

  // Footer
  void onEmoticonTap(int index) {

  }

  // 이미지 선택 버튼
  void onPickImage() async {
    final image = await ImagePicker().pickImage(
      // source: ImageSource.camera   // 카메라로 직접 촬영
      source: ImageSource.gallery   // 갤러리에서 이미지 선택
    );

    // 상태 변경 시 setState() 함수 실행
    // 값 변경 시 build() 함수 재실행
    // Clean -> setState() -> Dirty -> build() -> Clean
    setState(() {
      this.image = image;   // 선택한 이미지 저장
    });
  }

  // 이미지 삭제 버튼
  void onDeleteImage() {

  }

  // 이미지 저장 버튼
  void onSaveImage() {

  }
}