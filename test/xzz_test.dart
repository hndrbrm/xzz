// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:test/test.dart';
import 'package:xzz/xzz.dart';

void main() {
  test('Serialize Test', () {
    final file = File('${Directory.current.path}/test/pcb/iPhone4S boardview.pcb');
    final content = file.readAsBytesSync();
    final xzz = content.iterator.toXzz();
    final bytes = xzz.toBytes();
    expect(bytes, equals(content));
  });
}
