// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';
import 'length_packet.dart';

class BytesablePacket<T>
with IterableMixin<T>
implements Bytesable, Jsonable
{
  const BytesablePacket(this.whole);

  final List<T> whole;

  @override
  Iterator<T> get iterator => whole.iterator;

  @override
  Bytes toBytes() => [
    for (final each in whole)
    ...(each as Bytesable).toBytes(),
  ].toBytesable().toLengthPacket().toBytes();

  @override
  JsonList toJson() => whole
    .map((e) => e as Jsonable)
    .map((e) => e.toJson())
    .toJsonList();
}

extension BytesablePacketOnIterator on Iterator<int> {
  BytesablePacket<T> toBytesablePacket<T extends Bytesable>(T Function(Iterator<int> iterator) debyte) {
    final packet = toLengthPacket()!.content.toBytes();
    final packetIterator = packet.iterator;

    final whole = <T>[];

    for (var offset = 0; offset < packet.length; ) {
      final each = debyte(packetIterator);
      whole.add(each);
      offset += each.toBytes().length;
    }

    return BytesablePacket<T>(whole);
  }
}

extension BytesablePacketOnMap on Map<String, Object?> {
  BytesablePacket<T> toBytesablePacket<T>() {
    final whole = this['whole']! as List<T>;
    return BytesablePacket<T>(whole);
  }
}
