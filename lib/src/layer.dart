// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'shareable/int_helper.dart';
import 'shareable/iterator_helper.dart';
import 'shareable/list_helper.dart';
import 'shareable/serializer.dart';

final class Layer implements Serializer {
  const Layer._({
    required this.id,
    required this.order,
    required this.unknown1,
    required this.unknown2,
    required this.data,
  });

  factory Layer.deserialize(Iterator<int> iterator) {
    final id = iterator.read(1).first;
    assert(id == 0x0a);

    final order = iterator.read(2).toUint16();

    final unknown1 = iterator.read(4).toUint32();

    final unknown2 = iterator.read(4).toUint32();

    final length = iterator.read(4).toUint32();
    assert(length > 0);

    final data = iterator.read(length);

    return Layer._(
      id: id,
      order: order,
      unknown1: unknown1,
      unknown2: unknown2,
      data: data,
    );
  }

  final int id;
  final int order;
  final int unknown1;
  final int unknown2;
  final List<int> data;

  @override
  List<int> serialize() => [
    id,
    ...order.toUint16List(),
    ...unknown1.toUint32List(),
    ...unknown2.toUint32List(),
    ...data.length.toUint32List(),
    ...data,
  ];
}
