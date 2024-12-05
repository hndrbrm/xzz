// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'layer.dart';
import 'shareable/int_helper.dart';
import 'shareable/iterator_helper.dart';
import 'shareable/list_helper.dart';
import 'shareable/serializer.dart';

final class Layers implements Serializer {
  const Layers._({
    required this.layers,
  });

  factory Layers.deserialize(Iterator<int> iterator) {
    final length = iterator.read(4).toUint32();

    final layers = <Layer>[];

    for (var offset = 0; offset < length; ) {
      final layer = Layer.deserialize(iterator);
      layers.add(layer);
      offset += layer.serialize().length;
    }

    return Layers._(layers: layers);
  }

  final List<Layer> layers;

  @override
  List<int> serialize() {
    final body = [
      for (final layer in layers)
        ...layer.serialize(),
    ];

    return [
      ...body.length.toUint32List(),
      ...body,
    ];
  }
}
