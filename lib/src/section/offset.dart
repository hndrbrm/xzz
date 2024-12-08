// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../bytes_helper/int_helper.dart';
import '../bytes_helper/iterator_helper.dart';
import '../bytes_helper/list_helper.dart';
import '../serializer.dart';

/// The offset of the section [boardOffset], [imageOffset], [netOffset] are
/// relative to current section, means it need to add with 0x20 for the absolute
/// offset.
final class Offset implements Serializer {
  const Offset._({
    required this.boardOffset,
    required this.imageOffset,
    required this.netOffset,
  });

  factory Offset.deserialize(Iterator<int> iterator) {
    final unknown1 = iterator.read(20);
    if (!listEqual(unknown1, _unknown1)) {
      throw InvalidOffsetException();
    }

    final boardOffset = iterator.read(4).toUint32();
    if (boardOffset != 0x00000020) {
      throw InvalidOffsetException();
    }

    final imageOffset = iterator.read(4).toUint32();
    final netOffset = iterator.read(4).toUint32();

    final unknown2 = iterator.read(20);
    if (!listEqual(unknown2, _unknown2)) {
      throw InvalidOffsetException();
    }

    return Offset._(
      boardOffset: boardOffset,
      imageOffset: imageOffset,
      netOffset: netOffset,
    );
  }

  final int boardOffset;
  final int imageOffset;
  final int netOffset;

  static final _unknown1 = List<int>.filled(20, 0x00);
  static final _unknown2 = List<int>.filled(20, 0x00);

  @override
  List<int> serialize() => [
    ..._unknown1,
    ...boardOffset.toUint32List(),
    ...imageOffset.toUint32List(),
    ...netOffset.toUint32List(),
    ..._unknown2,
  ];
}

final class InvalidOffsetException extends FormatException {}
