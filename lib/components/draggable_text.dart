import 'package:flutter/material.dart';

class DraggableText extends StatefulWidget {
  final Offset initialPosition;
  final Function(String) onSubmitted;
  final VoidCallback onDelete;   // 삭제 콜백

  const DraggableText({
    super.key,
    required this.initialPosition,
    required this.onSubmitted,
    required this.onDelete,
  });

  @override
  State<DraggableText> createState() => _DraggableTextState();
}

class _DraggableTextState extends State<DraggableText> {
  late Offset position;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool isEditing = true;

  @override
  void initState() {
    super.initState();

    position = widget.initialPosition;

    // 위젯이 생성되자마자 자동으로 키보드 및 포커스 활성화
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
    });

    // 포커스가 해제될 때 (빈 공간 클릭 시)
    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        final text = _controller.text.trim();   // 앞뒤 공백 제거 후 검사

        // 텍스트가 비어있으면 부모에게 삭제 요청
        if (text.isEmpty) {
          widget.onDelete();
        } else {
          // 상태 변경 시 setState() 함수 실행
          // 값 변경 시 build() 함수 재실행
          // Clean -> setState() -> Dirty -> build() -> Clean
          setState(() {
            isEditing = false;
          });
          widget.onSubmitted(text);
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: position.dx,
      top: position.dy,
      child: GestureDetector(
        // 드래그로 위치 이동
        onPanUpdate: (details) {
          // 상태 변경 시 setState() 함수 실행
          // 값 변경 시 build() 함수 재실행
          // Clean -> setState() -> Dirty -> build() -> Clean
          setState(() {
            position += details.delta;
          });
        },
        // 입력 완료된 텍스트를 다시 탭하면 재수정 가능
        onTap: () {
          // 상태 변경 시 setState() 함수 실행
          // 값 변경 시 build() 함수 재실행
          // Clean -> setState() -> Dirty -> build() -> Clean
          setState(() {
            isEditing = true;
          });
          _focusNode.requestFocus();
        },
        child: Container(
          constraints: const BoxConstraints(
            minWidth: 100,
            maxWidth: 280
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4
          ),
          decoration: BoxDecoration(
            color: Colors.transparent,   // 배경은 완전히 투명하게 유지
            // 입력 중일 때만 점선 느낌의 반투명 테두리를 표시하고 완료되면 투명 처리
            border: isEditing
                    ? Border.all(color: Colors.blueAccent.withOpacity(0.7), width: 1.5)
                    : Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(6),
          ),
          child: IntrinsicWidth(
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              maxLines: null,   // 줄바꿈 허용
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                hintText: 'Please enter text',
                hintStyle: TextStyle(color: Colors.black38),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
