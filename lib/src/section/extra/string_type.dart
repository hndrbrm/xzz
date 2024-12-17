// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/iterator_helper.dart';
import '../../bytes_helper/list_helper.dart';
import '../../bytes_helper/string_helper.dart';
import '../../serializable/byteable.dart';

class StringType implements Bytesable {
  const StringType(this._content);

  final String _content;

  int get length => _content.length + 1;

  @override
  List<int> toBytes() => <int>[
    ..._content.toString8List(),
    0x0a,
  ];

  @override
  bool operator ==(Object other) =>
    other is StringType &&
    other._content == _content;

  @override
  int get hashCode => _content.hashCode;
}

extension StringTypeIterator on Iterator<int> {
  StringType toStringType() {
    final result = <int>[];

    for (;;) {
      final each = read(1).first;
      if (each == 0x0a) {
        break;
      }
      result.add(each);
    }

    return StringType(result.toString8());
  }
}

extension StringTypeList on List<int> {
  StringType toStringType() => iterator.toStringType();
}
