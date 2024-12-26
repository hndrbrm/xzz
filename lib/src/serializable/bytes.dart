// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'package:fast_gbk/fast_gbk.dart';

import 'text.dart';

typedef Bytes = List<int>;

extension BytesOnIterator on Iterator<int> {
  Bytes read(int length) {
    assert(!length.isNegative);

    final buffer = <int>[];

    for (var i = 0; i < length && moveNext(); i++) {
      buffer.add(current);
    }

    return buffer;
  }

  Bytes toBytes() {
    final result = <int>[];
    while (moveNext()) {
      result.add(current);
    }

    return result;
  }
}

extension BytesOnText on Text {
  Bytes toBytes() => gbk.encode(this);
}
