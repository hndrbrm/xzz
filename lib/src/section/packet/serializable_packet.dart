// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import '../../serializer.dart';
import 'length_packet.dart';

class SerializablePacket<T extends Serializer> with IterableMixin<T> implements Serializer {
  SerializablePacket.deserialize(Iterator<int> iterator, T Function(Iterator<int> iterator) deserialize)
  : _ts = _deserialize(iterator, deserialize);

  static List<T> _deserialize<T extends Serializer>(
    Iterator<int> iterator,
    T Function(Iterator<int> iterator) deserialize,
  ) {
    final packet = LengthPacket.deserialize(iterator);
    final packetIterator = packet.content.iterator;

    final ts = <T>[];

    for (var offset = 0; offset < packet.content.length; ) {
      final t = deserialize(packetIterator);
      ts.add(t);
      offset += t.serialize().length;
    }

    return ts;
  }

  final List<T> _ts;

  @override
  Iterator<T> get iterator => _ts.iterator;

  @override
  List<int> serialize() => [
    for (final t in _ts)
    ...t.serialize(),
  ].toLengthPacket().serialize();
}
