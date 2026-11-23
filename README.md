# Image Editor

Apps that allow image editing.

- Flutter 3.47.7
- Dart 3.13.5

## Preparation

- Gesture Parameters
- Gallery native permissions settings.

## Key Components

- ImagePicker
- XFile
- GestureDetector
- RepaintBoundary
- InteractiveViewer
- SingleChildScrollView
- Transform
    - Matrix4
- hashCode
- '==' Operator override

## Additional Components

- HitTestBehavior
- FocusScope
- Offset

## Plugin

- gal: ^2.3.3
- image_picker: ^1.2.4
- uuid: ^4.6.0

## Features

- Select an image in the gallery
- Add to the text input box image
    - Edit and delete
    - Move location
- Tap the sticker to add it to the image
    - Resize and move
- Press the delete button to remove the added sticker
- Tap the Save button to store the modified image in the gallery
    - Available for saving to a specified folder only on Android
- Tap an empty area of the screen to remove the selection border for text and stickers
- Changing the image you were working on will delete all text and stickers on the screen

## 기능

- 갤러리에서 이미지 선택
- 텍스트 입력창 이미지에 추가
    - 편집 및 삭제
    - 위치 이동
- 스티커를 탭 해서 이미지에 추가
    - 크기 조절 및 위치 이동
- 삭제 버튼을 눌러서 추가한 스티커 삭제
- 저장 버튼을 눌러서 수정한 이미지를 갤러리에 저장
    - 안드로이드에 한 해 지정한 폴더에 저장 가능
- 화면의 빈 공간을 탭 하면 글자 및 스티커의 선택 상태 테두리 해제
- 작업 중이던 이미지를 변경하면 화면에 있는 글자 및 스티커 모두 삭제