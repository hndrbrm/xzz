// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

extension IteratorTypeUtility on Iterator<int> {
  List<int> read(int length) {
    assert(!length.isNegative);

    final buffer = <int>[];

    for (var i = 0; i < length && moveNext(); i++) {
      buffer.add(current);
    }

    return buffer;
  }
}
