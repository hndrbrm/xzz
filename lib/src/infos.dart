// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'info.dart';
import 'shareable/int_helper.dart';
import 'shareable/iterator_helper.dart';
import 'shareable/list_helper.dart';
import 'shareable/serializer.dart';

final class Infos implements Serializer {
  Infos._({
    required this.infos,
  });

  factory Infos.deserialize(Iterator<int> iterator) {
    final length = iterator.read(4).toUint32();

    final infos = <Info>[];

    for (var offset = 0; offset < length; ) {
      final container = InfoContainer.deserialize(iterator);
      infos.add(container.info);
      offset += container.serialize().length;
    }

    return Infos._(infos: infos);
  }

  final List<Info> infos;

  @override
  List<int> serialize() {
    final body = [
      for (final info in infos)
      ...InfoContainer(info).serialize(),
    ];

    return [
      ...body.length.toUint32List(),
      ...body,
    ];
  }
}
