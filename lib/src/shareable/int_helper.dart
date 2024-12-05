// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

extension IntExtension on int {
  List<int> toUint16List([ Endian endian = Endian.little ]) {
    if (endian == Endian.little) {
      return [
        this & 0xff,
        (this >> 8) & 0xff,
      ];
    } else {
      return [
        (this >> 8) & 0xff,
        this & 0xff,
      ];
    }
  }

  List<int> toUint32List([ Endian endian = Endian.little ]) {
    if (endian == Endian.little) {
      return [
        this & 0xff,
        (this >> 8) & 0xff,
        (this >> 16) & 0xff,
        (this >> 24) & 0xff,
      ];
    } else {
      return [
        (this >> 24) & 0xff,
        (this >> 16) & 0xff,
        (this >> 8) & 0xff,
        this & 0xff,
      ];
    }
  }

  List<int> toInt32List([Endian endian = Endian.little]) =>
    (this & 0xFFFFFFFF).toUint32List(endian);
}
