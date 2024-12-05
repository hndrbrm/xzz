// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

extension IntListExtension on List<int> {
  String toHex([ int offset = 0, int? length ]) {
    final buffer = StringBuffer();
    for (var i = offset; i < (length ?? this.length); i++) {
      final hex = elementAt(i).toRadixString(16).padLeft(2, '0');
      buffer.write(hex);
    }
    return buffer.toString();
  }

  int toUint32([ int offset = 0, Endian endian = Endian.little ]) {
    assert(length >= offset + 4);

    if (endian == Endian.little) {
      return
        this[offset] |
        this[offset + 1] << 8 |
        this[offset + 2] << 16 |
        this[offset + 3] << 24;
    } else {
      return
        this[offset] << 24 |
        this[offset + 1] << 16 |
        this[offset + 2] << 8 |
        this[offset + 3];
    }
  }

  int toInt32([ int offset = 0, Endian endian = Endian.little ]) {
    final value = toUint32(offset, endian);
    return value & 0x80000000 == 0 ? value : value - 0x100000000;
  }

  int toUint16([ int offset = 0, Endian endian = Endian.little ]) {
    assert(length >= offset + 2);

    if (endian == Endian.little) {
      return
        this[offset] |
        this[offset + 1] << 8;
    } else {
      return
        this[offset] << 8 |
        this[offset + 1];
    }
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
