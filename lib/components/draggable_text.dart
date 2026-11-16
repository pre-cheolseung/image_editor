import 'package:flutter/material.dart';

// 텍스트 입력창을 그리는 위젯
class DraggableText extends StatefulWidget {
  final Offset initialPosition;
  final Function(String) onSubmitted;
  final VoidCallback onDelete;   // 삭제 콜백

  // const 생성자 : 최초 선언 후 변경 불가능한 빌드 타임 함수
  const DraggableText({
    required this.initialPosition,
    required this.onSubmitted,
    required this.onDelete,
    Key? key,
  }) : super(key: key);

  @override
  // State<DraggableText> createState() => _DraggableTextState();
  State<DraggableText> createState() {
    return _DraggableTextState();
  }
}

class _DraggableTextState extends State<DraggableText> {
  late Offset _position;
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isEditing = true;

  @override
  void initState() {
    super.initState();

    _position = widget.initialPosition;

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
            _isEditing = false;
          });

          widget.onSubmitted(text);
        }
      }
    });
  }

  void _startEditing() {
    if (_isEditing) return;
    setState(() {
      _isEditing = true;
    });

    // 상태 변경 후 프레임에서 포커스를 요청해야 안정적으로 커서가 잡힘
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _focusNode.requestFocus();
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
      left: _position.dx,
      top: _position.dy,
      child: GestureDetector(
        // 드래그로 위치 이동
        onPanUpdate: (details) {
          // 상태 변경 시 setState() 함수 실행
          // 값 변경 시 build() 함수 재실행
          // Clean -> setState() -> Dirty -> build() -> Clean
          setState(() {
            _position += details.delta;
          });
        },
        onTap: _startEditing,
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
            border: _isEditing
              ? Border.all(color: Colors.blueAccent.withValues(alpha: 0.7), width: 1.5)
              : Border.all(color: Colors.transparent),
            borderRadius: BorderRadius.circular(6),
          ),
          // Row로 감싸서 TextField와 삭제 버튼의 너비를 명확하게 분리
          child: Row(
            // 주축 방향으로 남은 빈 공간을 최대한 채우지 않고
            // 포함된 자식(child) 위젯들의 크기 합만큼만 영역을 차지
            mainAxisSize: MainAxisSize.min,
            // 교차축(crossAxis)의 중앙에 자식(child) 위젯들을 정렬
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: IntrinsicWidth(
                  child: TextField(
                    controller: _controller,
                    focusNode: _focusNode,
                    // 편집 모드가 아닐 때 터치 가로채는 것을 방지하고 _startEditing 연결
                    readOnly: !_isEditing,
                    onTap: !_isEditing ? _startEditing : null,
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
              // 편집 모드일 때만 텍스트 유무에 따라 삭제 아이콘 렌더링
              if (_isEditing)
                ValueListenableBuilder<TextEditingValue>(
                  valueListenable: _controller,   // _controller 값 변경만 감지
                  builder: (context, value, child) {
                    // 텍스트가 비어있으면 아이콘 숨김
                    if (value.text.isEmpty) {
                      return const SizedBox.shrink();
                    }
                    return GestureDetector(
                      onTap: () {
                        _controller.clear();
                        _focusNode.requestFocus();   // 텍스트 삭제 후에도 입력 포커스 유지
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(left: 6),
                        child: Icon(
                          Icons.cancel,
                          color: Colors.grey,
                          size: 18,
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}