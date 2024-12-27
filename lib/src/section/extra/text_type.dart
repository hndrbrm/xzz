// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/text.dart';

class TextType implements Bytesable {
  const TextType(this.content);

  final String content;

  int get length => content.length + 1;

  @override
  Bytes toBytes() => [
    ...content.toBytes(),
    0x0a,
  ];

  @override
  bool operator ==(Object other) =>
    other is TextType &&
    other.content == content;

  @override
  int get hashCode => content.hashCode;
}

final class TextTypeNotFoundException implements Exception {}

extension TextTypeOnBytes on Bytes {
  TextType toStringType() => iterator.toTextType();
}

extension TextTypeOnIterator on Iterator<int> {
  TextType toTextType() {
    final result = <int>[];

    for (;;) {
      final probe = read(1);
      if (probe.isEmpty) {
        throw TextTypeNotFoundException();
      }

      final each = probe.first;
      if (each == 0x0a) {
        break;
      }
      result.add(each);
    }

    return TextType(result.toText());
  }
}

extension TextTypeOnString on String {
  TextType toTextType() => TextType(this);
}
