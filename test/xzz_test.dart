// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:test/test.dart';
import 'package:xzz/xzz.dart';

void main() {
  late List<int> bytes;

  setUp(() {
    final file = File('${Directory.current.path}/test/pcb/Switch Card slot YiDianTong.pcb');
    bytes = file.readAsBytesSync();
  });

  test('Bytes Serialization', () {
    final xzz = bytes.toXzz();
    final probeBytes = xzz.toBytes();
    expect(probeBytes, equals(bytes));
  });

  test('Json Serialization', () {
    final xzz = bytes.toXzz();
    final json = xzz.toJson();
    final probeXzz = json.toXzz();
    expect(xzz, equals(probeXzz));
  });
}
