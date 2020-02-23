import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as image_lib;

import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo/constants/colors.dart' as ttd_colors;
import 'package:toptodo/widgets/td_shape.dart';

void main() {
  group('TdShape', () {
    testWidgets('long side left', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final image = await _createImage(
          width: 400.0,
          height: 800.0,
          longSide: LongSide.left,
        );

        isPainted(image, 10, 10);
        isPainted(image, 10, 770);
        isNotPainted(image, 390, 10);
        isNotPainted(image, 390, 770);
      });
    });

    testWidgets('long side top', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final image = await _createImage(
          width: 400.0,
          height: 800.0,
          longSide: LongSide.top,
        );

        isNotPainted(image, 10, 10);
        isNotPainted(image, 10, 770);
        isPainted(image, 390, 10);
        isNotPainted(image, 390, 770);
      });
    });

    testWidgets('long side right', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final image = await _createImage(
          width: 400.0,
          height: 800.0,
          longSide: LongSide.right,
        );

        isNotPainted(image, 10, 10);
        isNotPainted(image, 10, 770);
        isPainted(image, 390, 10);
        isPainted(image, 390, 770);
      });
    });

    testWidgets('long side bottom', (WidgetTester tester) async {
      await tester.runAsync(() async {
        final image = await _createImage(
          width: 400.0,
          height: 800.0,
          longSide: LongSide.bottom,
        );

        isNotPainted(image, 10, 10);
        isNotPainted(image, 10, 770);
        isNotPainted(image, 390, 10);
        isPainted(image, 390, 770);
      });
    });
  });
}

Future<image_lib.Image> _createImage(
    {double width, double height, LongSide longSide}) async {
  final recorder = PictureRecorder();
  final canvas = Canvas(recorder);
  final tdShape = TdShape(longSide, ttd_colors.forest100);

  tdShape.paint(canvas, Size(width, height));

  final picture = recorder.endRecording();
  final pictureImage = await picture.toImage(
    width.floor(),
    height.floor(),
  );
  final byteData = await pictureImage.toByteData(
    format: ui.ImageByteFormat.png,
  );

  return image_lib.decodeImage(byteData.buffer.asUint8List());
}

void isPainted(image_lib.Image image, int x, int y) =>
    expect(_argbIsAbgr(ttd_colors.forest100, image.getPixel(x, y)), isTrue);

void isNotPainted(image_lib.Image image, int x, int y) =>
    expect(image.getPixel(x, y), isZero);

bool _argbIsAbgr(Color color, int value) =>
    (color.alpha == _alphaFromAbgr(value)) &&
    (color.red == _redFromAbgr(value)) &&
    (color.green == _greenFromAbgr(value)) &&
    (color.blue == _blueFromAbgr(value));

int _alphaFromAbgr(int value) => (0xff000000 & value) >> 24;
int _blueFromAbgr(int value) => (0x00ff0000 & value) >> 16;
int _greenFromAbgr(int value) => (0x0000ff00 & value) >> 8;
int _redFromAbgr(int value) => (0x000000ff & value) >> 0;
