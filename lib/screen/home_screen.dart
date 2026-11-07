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

import 'dart:io';   // 파일 관련 기능 사용

import 'package:flutter/material.dart';

import 'package:image_editor/components/emoticon_sticker.dart';
import 'package:image_editor/components/footer.dart';
import 'package:image_editor/components/main_app_bar.dart';
import 'package:image_editor/model/sticker_model.dart';

import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

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
  String? selectedId;   // 현재 선택된 스티커 ID
  Set<StickerModel> stickers = {};   // 화면에 추가된 스티커를 저장할 변수

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // 스크린에 Body, AppBar, Footer 순서로 쌓을 준비
      body: Stack(
        fit: StackFit.expand,   // 자식 위젯들을 최대 크기로 확대
        children: [
          renderBody(),
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

  Widget renderBody() {
    if (image != null) {
      // Stack의 최대 크기만큼 차지
      return Positioned.fill(
        // 위젯이 확대 및 좌우 이동을 가능하게 하는 위젯
        child: InteractiveViewer(
          child: Stack(
            fit: StackFit.expand,   // 최대 크기로 확대
            children: [
              Image.file(
                File(image!.path),
                fit: BoxFit.cover,   // 이미지가 부모 위젯의 최대 크기를 차지
              ),
              ...stickers.map(
                // 스티커 최초 선택 시 중앙에 배치
                (sticker) => Center(
                  child: EmoticonSticker(
                    key: ObjectKey(sticker.id),
                    onTransform: () {
                      onTransform(sticker.id);   // 스티커 ID 값을 함수의 매개변수로 전달
                    },
                    imgPath: sticker.imgPath,
                    isSelected: selectedId == sticker.id,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // 이미지 선택이 안 되어 있는 경우 이미지 선택 버튼 표시
      return Center(
        child: TextButton(
          onPressed: onPickImage,
          child: Text('Select Image'),
          style: TextButton.styleFrom(
            foregroundColor: Colors.grey
          ),
        ),
      );
    }
  }

  // Footer
  // 스티커를 누를 때마다 실행
  void onEmoticonTap(int index) async {
    // 상태 변경 시 setState() 함수 실행
    // 값 변경 시 build() 함수 재실행
    // Clean -> setState() -> Dirty -> build() -> Clean
    setState(() {
      stickers = {
        ...stickers,
        StickerModel(
          id: Uuid().v4(),   // 스티커의 고유 ID를 절대로 겹치지 않는 String 값으로 생성
          imgPath: 'assets/img/emoticon_$index.png',
        ),
      };
    });
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
    // 상태 변경 시 setState() 함수 실행
    // 값 변경 시 build() 함수 재실행
    // Clean -> setState() -> Dirty -> build() -> Clean
    setState(() {
      stickers = stickers.where((sticker) => sticker.id != selectedId).toSet();   // 현재 선택돼 있는 스티커 삭제 후 Set로 변환
    });
  }

  // 이미지 저장 버튼
  void onSaveImage() {

  }

  // 스티커의 상태가 변경될 때마다 변경 중인 스티커를 현재 선택한 스티커로 지정
  void onTransform(String id) {
    // 상태 변경 시 setState() 함수 실행
    // 값 변경 시 build() 함수 재실행
    // Clean -> setState() -> Dirty -> build() -> Clean
    setState(() {
      selectedId = id;
    });
  }
}