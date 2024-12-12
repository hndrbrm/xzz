// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

extension ListExtension on List<int> {
  String toHex([ int offset = 0, int? length ]) {
    final buffer = StringBuffer();
    for (var i = offset; i < (length ?? this.length); i++) {
      final hex = elementAt(i).toRadixString(16).padLeft(2, '0');
      buffer.write(hex);
    }
    return buffer.toString();
  }

  int toUint32() {
    assert(length >= 4);

    return
      this[0] |
      this[1] << 8 |
      this[2] << 16 |
      this[3] << 24;
  }

  int toInt32() {
    final value = toUint32();
    return value & 0x80000000 == 0 ? value : value - 0x100000000;
  }

  int toUint16() {
    assert(length >= 2);

    return
      this[0] |
      this[1] << 8;
  }

  String toString8() => utf8.decode(this);
}

bool listEqual(List a, List b) {
  if (a.length != b.length) {
    return false;
  }

  for (var i = 0; i < a.length; i++) {
    if (a[i] != b[i]) {
      return false;
    }
  }

  return true;
}
