import 'package:flutter/material.dart';

class MainAppBar extends StatelessWidget {
  final VoidCallback onPickImage;   // 이미지 선택 버튼을 눌렀을 때 실행할 함수
  final VoidCallback onSaveImage;   // 이미지 저장 버튼을 눌렀을 때 실행할 함수
  final VoidCallback onDeleteImage;   // 이미지 삭제 버튼을 눌렀을 때 실행할 함수

  // const 생성자 : 최초 선언 후 변경 불가능한 빌드 타임 함수
  const MainAppBar({
    required this.onPickImage,
    required this.onSaveImage,
    required this.onDeleteImage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
      ),
      child: Row(
        // 자식(child) 위젯들 사이에 균등한 간격을 두고,
        // 양쪽 끝(시작과 끝)에는 그 간격의 절반 크기만큼의 여백을 배치하는 정렬 
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        // 교차축(crossAxis)의 끝부분에 자식(child) 위젯들을 정렬
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // 이미지 선택 버튼
          IconButton(
            onPressed: onPickImage,
            icon: Icon(
              Icons.image_search_outlined,
              color: Colors.grey[700],
            ),
          ),
          // 이미지 삭제 버튼
          IconButton(
            onPressed: onDeleteImage,
            icon: Icon(
              Icons.delete_forever_outlined,
              color: Colors.grey[700],
            ),
          ),
          // 이미지 저장 버튼
          IconButton(
            onPressed: onSaveImage,
            icon: Icon(
              Icons.save,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }
}