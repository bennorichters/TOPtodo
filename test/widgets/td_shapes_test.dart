import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image/image.dart' as img;

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:toptodo/utils/colors.dart';
import 'package:toptodo/widgets/td_shapes.dart';

class MockCanvas extends Mock implements Canvas {}

void main() {

  testWidgets('better name needed', (WidgetTester tester) async {
    final PictureRecorder recorder = PictureRecorder();
    final Canvas canvas = Canvas(recorder);
    final TdShape tdShape = TdShape();

    tdShape.paint(canvas, const Size(400, 425));

    final Picture picture = recorder.endRecording();
    final ui.Image image = await picture.toImage(400, 425);
    final ByteData bd = await image.toByteData();
    final List<int> values = bd.buffer.asUint8List();

    final img.Image myImage = img.decodeImage(values);
    final int pixel = myImage.getPixel(10, 10);
    print('${forest100.value} $pixel');
  });
}
