// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../byteable.dart';
import '../../bytes_helper/int_helper.dart';
import '../../bytes_helper/iterator_helper.dart';
import '../../bytes_helper/list_helper.dart';

class LengthPacket implements Byteable {
  const LengthPacket(this.content);

  final Byteable content;

  @override
  List<int> toByte() {
    final byte = content.toByte();

    return [
      ...byte.length.toUint32List(),
      ...byte,
    ];
  }
}

extension LengthPacketList on List<int> {
  LengthPacket toLengthPacket() => iterator.toLengthPacket();
}

extension LengthPacketIterator on Iterator<int> {
  LengthPacket toLengthPacket() {
    final length = read(4).toUint32();
    final body = read(length);

    return body.toByteable().toLengthPacket();
  }
}

extension LengthPacketByteable on Byteable {
  LengthPacket toLengthPacket() => LengthPacket(this);
}
