import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

import 'package:flutter_test/flutter_test.dart';
import 'package:toptodo/utils/colors.dart';
import 'package:toptodo/widgets/td_shapes.dart';

void main() {
  testWidgets('better name needed', (WidgetTester tester) async {
    await tester.runAsync(() async {
      final PictureRecorder recorder = PictureRecorder();
      final Canvas canvas = Canvas(recorder);
      final TdShape tdShape = TdShape();

      tdShape.paint(canvas, const Size(400, 425));

      final Picture picture = recorder.endRecording();
      final ui.Image image = await picture.toImage(400, 425);
      final ByteData bd = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );
      final List<int> values = bd.buffer.asUint8List();
      final img.Image myImage = img.decodeImage(values);

      expect(_argbIsAbgr(forest100, myImage.getPixel(10, 10)), isTrue);
    });
  });
}

bool _argbIsAbgr(Color color, int value) =>
    (color.alpha == _alphaFromAbgr(value)) &&
    (color.red == _redFromAbgr(value)) &&
    (color.green == _greenFromAbgr(value)) &&
    (color.blue == _blueFromAbgr(value));

int _alphaFromAbgr(int value) => (0xff000000 & value) >> 24;
int _blueFromAbgr(int value) => (0x00ff0000 & value) >> 16;
int _greenFromAbgr(int value) => (0x0000ff00 & value) >> 8;
int _redFromAbgr(int value) => (0x000000ff & value) >> 0;
