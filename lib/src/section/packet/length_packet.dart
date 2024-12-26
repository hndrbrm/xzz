// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/int_helper.dart';
import '../../bytes_helper/list_helper.dart';
import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';

class LengthPacket implements Bytesable {
  const LengthPacket(this.content);

  final Bytesable content;

  @override
  Bytes toBytes() {
    final byte = content.toBytes();

    return [
      ...byte.length.toUint32List(),
      ...byte,
    ];
  }
}

extension LengthPacketOnBytesable on Bytesable {
  LengthPacket toLengthPacket() => LengthPacket(this);
}

extension LengthPacketOnIterator on Iterator<int> {
  LengthPacket? toLengthPacket() {
    final probe = read(4);
    if (probe.isEmpty) {
      return null;
    }

    final length = probe.toUint32();
    final body = read(length);

    return body.toBytesable().toLengthPacket();
  }
}
