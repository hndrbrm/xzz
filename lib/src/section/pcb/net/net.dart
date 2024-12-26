// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../../bytes_helper/int_helper.dart';
import '../../../bytes_helper/iterator_helper.dart';
import '../../../bytes_helper/list_helper.dart';
import '../../../bytes_helper/string_helper.dart';
import '../../../serializable/byteable.dart';
import '../../../serializable/jsonable.dart';

final class Net implements Bytesable, Jsonable {
  const Net._({
    required this.index,
    required this.name,
  });

  final int index;
  final String name;

  @override
  List<int> toBytes() => [
    ...(name.length + 8).toUint32List(),
    ...index.toUint32List(),
    ...name.toString8List(),
  ];

  @override
  JsonMap toJson() => {
    'index': index,
    'name': name,
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Net &&
    other.index == index &&
    other.name == name;

  @override
  int get hashCode => Object.hash(
    index,
    name,
  );
}

extension NetIterator on Iterator<int> {
  Net toNet() {
    final length = read(4).toUint32();

    return Net._(
      index: read(4).toUint32(),
      name: read(length - 8).toString8(),
    );
  }
}

extension NetJsonMap on JsonMap {
  Net toNet() => toObject().toNet();
}

extension NetMap on Map<String, Object?> {
  Net toNet() => Net._(
    index: this['index']! as int,
    name: this['name']! as String,
  );
}
