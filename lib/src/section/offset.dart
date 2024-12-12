// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../byteable.dart';
import '../bytes_helper/int_helper.dart';
import '../bytes_helper/iterator_helper.dart';
import '../bytes_helper/list_helper.dart';
import '../mappable.dart';

/// The offset of the section [boardOffset], [imageOffset], [netOffset] are
/// relative to current section, means it need to add with 0x20 for the absolute
/// offset.
final class Offset implements Byteable, Mappable {
  const Offset._({
    required this.unknown1,
    required this.boardOffset,
    required this.imageOffset,
    required this.netOffset,
    required this.unknown2,
  });

  final List<int> unknown1;
  final int boardOffset;
  final int imageOffset;
  final int netOffset;
  final List<int> unknown2;

  @override
  List<int> toByte() => [
    ...unknown1,
    ...boardOffset.toUint32List(),
    ...imageOffset.toUint32List(),
    ...netOffset.toUint32List(),
    ...unknown2,
  ];

  @override
  Map<String, dynamic> toMap() => {
    'unknown1': unknown1,
    'boardOffset': boardOffset,
    'imageOffset': imageOffset,
    'netOffset': netOffset,
    'unknown2': unknown2,
  };
}

final class InvalidOffsetException extends FormatException {}

extension OffsetMap on Map<String, dynamic> {
  Offset toOffset() => Offset._(
    unknown1: this['unknown1'],
    boardOffset: this['boardOffset'],
    imageOffset: this['imageOffset'],
    netOffset: this['netOffset'],
    unknown2: this['unknown2'],
  );
}

extension OffsetIterator on Iterator<int> {
  Offset toOffset() => Offset._(
    unknown1: read(21),
    boardOffset: read(4).toUint32(),
    imageOffset: read(4).toUint32(),
    netOffset: read(4).toUint32(),
    unknown2: read(20),
  );
}
