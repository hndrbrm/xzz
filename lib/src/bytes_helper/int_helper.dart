// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

extension IntExtension on int {
  List<int> toUint16List() => [
    this & 0xff,
    (this >> 8) & 0xff,
  ];

  List<int> toUint32List() => [
    this & 0xff,
    (this >> 8) & 0xff,
    (this >> 16) & 0xff,
    (this >> 24) & 0xff,
  ];

  List<int> toInt32List() => (this & 0xFFFFFFFF).toUint32List();
}
