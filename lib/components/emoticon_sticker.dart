import 'package:flutter/material.dart';

// 스티커를 그리는 위젯
class EmoticonSticker extends StatefulWidget {
  final VoidCallback onTransform;   // 상태가 변경된다는 것을 부모 위젯에 알리는 함수
  final String imgPath;   // 이미지 경로

  // const 생성자 : 최초 선언 후 변경 불가능한 빌드 타임 함수
  const EmoticonSticker({
    required this.onTransform,
    required this.imgPath,
    Key? key,
  }) : super(key: key);

  @override
  // State<EmoticonSticker> createState() => _EmoticonSticker();
  State<EmoticonSticker> createState() {
    return _EmoticonStickerState();
  }
}

class _EmoticonStickerState extends State<EmoticonSticker> {
  double scale = 1;   // 확대 및 축소 배율
  double hTransform = 0;   // 가로 움직임
  double vTransform = 0;   // 세로 움직임
  double actualScale = 1;   // 위젯의 초기 크기 기준 확대 및 축소 배율

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // 스티커를 눌렀을 때 실행할 함수
      onTap: () {
        widget.onTransform();   // 스티커의 상태가 변경될 때마다 실행
      },
      // 스티커의 확대 비율이 변경될 때 실행
      onScaleUpdate: (ScaleUpdateDetails details) {
        widget.onTransform();

        // 상태 변경 시 setState() 함수 실행
        // 값 변경 시 build() 함수 재실행
        // Clean -> setState() -> Dirty -> build() -> Clean
        setState(() {
          scale = details.scale * actualScale;   // 최근 확대 비율 기반으로 실제 확대 비율 계산
          hTransform += details.focalPointDelta.dx;   // 가로 이동 거리 계산
          vTransform += details.focalPointDelta.dy;   // 세로 이동 거리 계산
        });
      },
      // 스티커의 확대 비율 변경이 완료될 때 실행
      onScaleEnd: (ScaleEndDetails details) {
        actualScale = scale;   // 확대 비율 저장
      },
      child: Image.asset(
        widget.imgPath,   // 이미지 경로
      ),
    );
  }
}