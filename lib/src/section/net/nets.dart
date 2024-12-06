// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../shareable/int_helper.dart';
import '../../shareable/iterator_helper.dart';
import '../../shareable/list_helper.dart';
import '../../shareable/serializer.dart';
import 'net.dart';

final class Nets implements Serializer {
  Nets._({
    required this.nets,
  });

  factory Nets.deserialize(Iterator<int> iterator) {
    final length = iterator.read(4).toUint32();

    final nets = <Net>[];

    for (var offset = 0; offset < length; ) {
      final net = Net.deserialize(iterator);
      nets.add(net);
      offset += net.serialize().length;
    }

    return Nets._(nets: nets);
  }

  final List<Net> nets;

  @override
  List<int> serialize() {
    final body = [
      for (final net in nets)
      ...net.serialize(),
    ];

    return [
      ...body.length.toUint32List(),
      ...body,
    ];
  }
}
