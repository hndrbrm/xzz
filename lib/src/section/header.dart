// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../shareable/int_helper.dart';
import '../shareable/iterator_helper.dart';
import '../shareable/list_helper.dart';
import '../shareable/serializer.dart';

final class Header implements Serializer {
  const Header._({
    required this.size36,
    required this.size40layer,
  });

  factory Header.deserialize(Iterator<int> iterator) {
    final fixed1 = iterator.read(20);
    if (!listEqual(fixed1, _fixed1)) {
      throw InvalidHeaderException();
    }

    final fixed2 = iterator.read(4).toUint32();
    if (fixed2 != _fixed2) {
      throw InvalidHeaderException();
    }

    final size36 = iterator.read(4).toUint32();
    final size40layer = iterator.read(4).toUint32();

    final fixed3 = iterator.read(20);
    if (!listEqual(fixed3, _fixed3)) {
      throw InvalidHeaderException();
    }

    return Header._(
      size36: size36,
      size40layer: size40layer,
    );
  }

  final int size36;
  final int size40layer;

  static final _fixed1 = List<int>.filled(20, 0x00);
  static const _fixed2 = 0x00000020;
  static final _fixed3 = List<int>.filled(20, 0x00);

  @override
  List<int> serialize() => [
    ..._fixed1,
    ..._fixed2.toUint32List(),
    ...size36.toUint32List(),
    ...size40layer.toUint32List(),
    ..._fixed3,
  ];
}

final class InvalidHeaderException extends FormatException {}
