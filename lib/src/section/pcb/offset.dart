// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/int_helper.dart';
import '../../bytes_helper/iterator_helper.dart';
import '../../bytes_helper/list_helper.dart';
import '../../serializable/byteable.dart';
import '../../serializable/jsonable.dart';

/// The offset of the section [boardOffset], [imageOffset], [netOffset] are
/// relative to current section, means it need to add with 0x20 for the absolute
/// offset.
final class Offset implements Bytesable, Jsonable {
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
  List<int> toBytes() => [
    ...unknown1,
    ...boardOffset.toUint32List(),
    ...imageOffset.toUint32List(),
    ...netOffset.toUint32List(),
    ...unknown2,
  ];

  @override
  JsonMap toJson() => {
    'unknown1': unknown1,
    'boardOffset': boardOffset,
    'imageOffset': imageOffset,
    'netOffset': netOffset,
    'unknown2': unknown2,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Offset &&
    listEqual(other.unknown1, unknown1) &&
    other.boardOffset == boardOffset &&
    other.imageOffset == imageOffset &&
    other.netOffset == netOffset &&
    listEqual(other.unknown2, unknown2);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(unknown1),
    boardOffset,
    imageOffset,
    netOffset,
    Object.hashAll(unknown2),
  );
}

final class InvalidOffsetException extends FormatException {}

extension OffsetIterator on Iterator<int> {
  Offset toOffset() => Offset._(
    unknown1: read(21),
    boardOffset: read(4).toUint32(),
    imageOffset: read(4).toUint32(),
    netOffset: read(4).toUint32(),
    unknown2: read(20),
  );
}

extension OffsetJsonMap on JsonMap {
  Offset toOffset() => toObject().toOffset();
}

extension OffsetMap on Map<String, Object?> {
  Offset toOffset() => Offset._(
    unknown1: (this['unknown1']! as List<Object?>).toBytes(),
    boardOffset: this['boardOffset']! as int,
    imageOffset: this['imageOffset']! as int,
    netOffset: this['netOffset']! as int,
    unknown2: (this['unknown2']! as List<Object?>).toBytes(),
  );
}
