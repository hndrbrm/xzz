// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:typed_data';

extension ListExtension<T> on List<T> {
  List<T> cut(int start, int end) {
    final result = sublist(start, end);
    removeRange(start, end);
    return result;
  }
}

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

bool listEqual(List a, List b, int offsetA, int offsetB, length) {
  assert(a.length >= offsetA + length);
  assert(b.length >= offsetB + length);

  for (var i = 0; i < length; i++) {
    if (a[offsetA + i] != b[offsetB + i]) {
      return false;
    }
  }

  return true;
}
