// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/int_helper.dart';
import '../../bytes_helper/list_helper.dart';
import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';

/// The offset of the section [_boardOffset], [_imageOffset], [_netOffset] are
/// relative to current section, means it need to add with 0x20 for the absolute
/// offset.
final class Offset implements Bytesable, Jsonable {
  const Offset._({
    required List<int> unknown1,
    required int boardOffset,
    required int imageOffset,
    required int netOffset,
    required List<int> unknown2,
  })
  : _unknown1 = unknown1,
    _boardOffset = boardOffset,
    _imageOffset = imageOffset,
    _netOffset = netOffset,
    _unknown2 = unknown2;

  final Bytes _unknown1;
  final int _boardOffset;
  final int _imageOffset;
  final int _netOffset;
  final Bytes _unknown2;

  @override
  Bytes toBytes() => [
    ..._unknown1,
    ..._boardOffset.toUint32List(),
    ..._imageOffset.toUint32List(),
    ..._netOffset.toUint32List(),
    ..._unknown2,
  ];

  @override
  JsonMap toJson() => {
    'unknown1': _unknown1,
    'boardOffset': _boardOffset,
    'imageOffset': _imageOffset,
    'netOffset': _netOffset,
    'unknown2': _unknown2,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Offset &&
    listEqual(other._unknown1, _unknown1) &&
    other._boardOffset == _boardOffset &&
    other._imageOffset == _imageOffset &&
    other._netOffset == _netOffset &&
    listEqual(other._unknown2, _unknown2);

  @override
  int get hashCode => Object.hash(
    Object.hashAll(_unknown1),
    _boardOffset,
    _imageOffset,
    _netOffset,
    Object.hashAll(_unknown2),
  );
}

final class InvalidOffsetException extends FormatException {}

extension OffsetOnBytes on Bytes {
  Offset toOffset() => iterator.toOffset();
}

extension OffsetOnIterator on Iterator<int> {
  Offset toOffset() => Offset._(
    unknown1: read(21),
    boardOffset: read(4).toUint32(),
    imageOffset: read(4).toUint32(),
    netOffset: read(4).toUint32(),
    unknown2: read(20),
  );
}

extension OffsetOnJsonMap on JsonMap {
  Offset toOffset() => toObject().toOffset();
}

extension OffsetOnMap on Map<String, Object?> {
  Offset toOffset() => Offset._(
    unknown1: (this['unknown1']! as List<Object?>).toBytes(),
    boardOffset: this['boardOffset']! as int,
    imageOffset: this['imageOffset']! as int,
    netOffset: this['netOffset']! as int,
    unknown2: (this['unknown2']! as List<Object?>).toBytes(),
  );
}
