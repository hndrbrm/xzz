// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/int_helper.dart';
import '../../bytes_helper/iterator_helper.dart';
import '../../bytes_helper/list_helper.dart';
import '../../serializer.dart';

class LengthPacket implements Serializer {
  const LengthPacket(this.content);

  LengthPacket.deserialize(Iterator<int> iterator)
  : this._internal(
    iterator.read(4).toUint32(),
    iterator
  );

  LengthPacket._internal(int length, Iterator<int> iterator)
  : this(iterator.read(length));

  final List<int> content;

  @override
  List<int> serialize() => [
    ...content.length.toUint32List(),
    ...content,
  ];
}

extension LengthPacketExtension on List<int> {
  LengthPacket toLengthPacket() => LengthPacket(this);
}
