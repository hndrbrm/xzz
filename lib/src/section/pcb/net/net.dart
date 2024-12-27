// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../../bytes_helper/int_helper.dart';
import '../../../bytes_helper/list_helper.dart';
import '../../../serializable/bytes.dart';
import '../../../serializable/bytesable.dart';
import '../../../serializable/jsonable.dart';
import '../../../serializable/text.dart';

final class Net implements Bytesable, Jsonable {
  const Net._({
    required int index,
    required String name,
  })
  : _index = index,
    _name = name;

  final int _index;
  final String _name;

  @override
  Bytes toBytes() => [
    ...(_name.length + 8).toUint32List(),
    ..._index.toUint32List(),
    ..._name.toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'index': _index,
    'name': _name,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Net &&
    other._index == _index &&
    other._name == _name;

  @override
  int get hashCode => Object.hash(
    _index,
    _name,
  );
}

extension NetOnIterator on Iterator<int> {
  Net toNet() {
    final length = read(4).toUint32();

    return Net._(
      index: read(4).toUint32(),
      name: read(length - 8).toText(),
    );
  }
}

extension NetOnJsonMap on JsonMap {
  Net toNet() => toObject().toNet();
}

extension NetOnMap on Map<String, Object?> {
  Net toNet() => Net._(
    index: this['index']! as int,
    name: this['name']! as String,
  );
}
