class StickerModel {
  final String id;
  final String imgPath;

  StickerModel({
    required this.id,
    required this.imgPath,
  });

  @override
  // '=='로 같은지 비교할 때 사용되는 로직
  bool operator == (Object other) {
    return (other as StickerModel).id == id;   // ID 값이 같은 인스턴스끼리 같은 스티커로 인식하고 중복 데이터는 제거
  }

  @override
  // Set에서 중복 여부를 결정하는 속성
  int get hashCode => id.hashCode;   // ID 값이 같으면 Set 안에서 같은 인스턴스로 인식
}