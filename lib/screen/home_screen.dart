import 'dart:io';   // 파일 관련 기능 사용
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';

import 'package:image_editor/components/emoticon_sticker.dart';
import 'package:image_editor/components/footer.dart';
import 'package:image_editor/components/main_app_bar.dart';
import 'package:image_editor/model/sticker_model.dart';

import 'package:gal/gal.dart';
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
  GlobalKey imgKey = GlobalKey();   // 이미지로 전환할 위젯에 입력해 줄 키값

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
    return GestureDetector(
      behavior: HitTestBehavior.opaque,   // 빈 공간을 눌렀을 때 터치 이벤트를 감지하기 위해 히트테스트 동작 설정
      onTap: () {
        // 외부 빈 곳을 누르면 모든 스티커의 선택을 해제
        setState(() {
          selectedId = null;   // 현재 선택된 스티커의 ID나 인덱스를 초기화
        });
      },
      // 전체 화면을 터치 감지 영역으로 만들기 위해 사용
      child: SizedBox.expand(
        child: RepaintBoundary(
          key: imgKey,   // 이미지 저장용 Key는 RepaintBoundary에 위치하는 것이 우월
          child: InteractiveViewer(
            maxScale: 4.0,   // 최대 4.0배까지 확대 가능 (Default : 2.5)
            minScale: 1.0,   // 최소 1.0배까지 축소 가능 (Default : 0.8)
            child: Stack(
              fit: StackFit.expand,   // 최대 크기로 확대
              children: [
                Image.file(
                  File(image!.path),
                  fit: BoxFit.cover,   // 이미지가 부모 위젯의 최대 크기를 차지
                ),
                // 스티커 목록 생성
                ...stickers.map(
                  // 스티커 최초 선택 시 중앙에 배치
                  (sticker) {
                    // 스티커의 개별 이동을 제대로 구현하려면 Center 대신
                    // Positioned(left: sticker.x, top: sticker.y) 구조와
                    // GestureDetector(onPanUpdate: ...) 조합이 필요
                    return Center( 
                      child: EmoticonSticker(
                        key: ObjectKey(sticker.id),
                        onTransform: () {
                          onTransform(sticker.id);   // 스티커 ID 값을 함수의 매개변수로 전달
                        },
                        imgPath: sticker.imgPath,
                        isSelected: selectedId == sticker.id,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  } else {
    return Center(
      child: TextButton(
        onPressed: onPickImage,
        child: const Text('Select Image'),
        style: TextButton.styleFrom(
          foregroundColor: Colors.grey,
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

      stickers.clear();   // 화면에 있는 스티커 모두 삭제
      // stickers = stickers.where((sticker) => false).toSet();   // 화면에 있는 스티커 모두 삭제
    });
  }

  // 이미지 삭제 버튼
  void onDeleteImage() async {
    // 상태 변경 시 setState() 함수 실행
    // 값 변경 시 build() 함수 재실행
    // Clean -> setState() -> Dirty -> build() -> Clean
    setState(() {
      stickers = stickers.where((sticker) => sticker.id != selectedId).toSet();   // 현재 선택돼 있는 스티커 삭제 후 Set로 변환
    });
  }

  // 이미지 저장 버튼
  // 이미지 저장 기능 구현 함수
  void onSaveImage() async {
    // 상태 변경 시 setState() 함수 실행
    // 값 변경 시 build() 함수 재실행
    // Clean -> setState() -> Dirty -> build() -> Clean
    setState(() {
      selectedId = null;   // 현재 선택된 스티커의 ID나 인덱스를 초기화
    });

    // setState()로 인한 화면 재빌드(스티커 해제)가 완료된 후 실행되도록 보장
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      RenderRepaintBoundary boundary = 
        imgKey.currentContext!.findRenderObject() as RenderRepaintBoundary;   // 화면에 렌더링된 바운더리 위젯을 검색 후 저장
      
      ui.Image image = await boundary.toImage();   // 바운더리를 이미지로 변경 (dart:ui 패키지 내의 Image 클래스)
      ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);   // ByteData 형태로 변경
      Uint8List imgBytes = byteData!.buffer.asUint8List();   // Unit8List 형태로 변경 (플러그인 필수 요구 사항)

      try {
        // 100% 화질(원본 바이트) 그대로 갤러리에 저장
        await Gal.putImageBytes(
          imgBytes,
          album: 'ImageEditor',   // 폴더 및 앨범명 지정
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.deepPurpleAccent,
            content: Text('Save success'),
            behavior: SnackBarBehavior.floating,   // 화면 위에 떠 있는 스타일
            duration: const Duration(seconds: 3),   // 보여주는 시간 5초로 설정 (Default : 4)
          ),
        );
      // 권한 부족, 용량 부족 등 에러 처리
      } on GalException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Save failed : ${e.type.name}'),
            behavior: SnackBarBehavior.floating,
            // 확인 버튼
            action: SnackBarAction(
              label: 'Confirm',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      // 알 수 없는 에러 처리
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Unknown error occurred : $e'),
            behavior: SnackBarBehavior.floating,
            action: SnackBarAction(
              label: 'Confirm',
              textColor: Colors.white,
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
            ),
          ),
        );
      }
    });
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