// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';

import 'shareable/int_helper.dart';
import 'shareable/iterator_helper.dart';
import 'shareable/list_helper.dart';
import 'shareable/serializer.dart';

final class Header implements Serializer {
  const Header._({
    required this.size36,
    required this.size40layer,
  });

  factory Header.deserialize(Iterator<int> iterator) {
    final fixed1 = List<int>.filled(20, 0x00);
    const fixed2 = 0x00000020;
    final fixed3 = List<int>.filled(20, 0x00);

    assert(ListEquality().equals(iterator.read(20), fixed1));
    assert(iterator.read(4).toUint32() == fixed2);

    final size36 = iterator.read(4).toUint32();
    final size40layer = iterator.read(4).toUint32();

    assert(ListEquality().equals(iterator.read(20), fixed3));

    return Header._(
      size36: size36,
      size40layer: size40layer,
    );
  }

  final int size36;
  final int size40layer;

  @override
  List<int> serialize() => [
    ...List<int>.filled(20, 0x00),
    ...0x00000020.toUint32List(),
    ...size36.toUint32List(),
    ...size40layer.toUint32List(),
    ...List<int>.filled(20, 0x00),
  ];
}
