// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../shareable/int_helper.dart';
import '../../shareable/iterator_helper.dart';
import '../../shareable/list_helper.dart';
import '../../shareable/serializer.dart';

class LengthPacket implements Serializer {
  const LengthPacket(this.content);

  factory LengthPacket.deserialize(Iterator<int> iterator) {
    final length = iterator.read(4).toUint32();
    final bytes = iterator.read(length);

    return LengthPacket(bytes);
  }

  final List<int> content;

  @override
  List<int> serialize() => [
    ...content.length.toUint32List(),
    ...content,
  ];
}
