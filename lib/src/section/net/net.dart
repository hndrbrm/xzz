// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import '../../bytes_helper/int_helper.dart';
import '../../bytes_helper/iterator_helper.dart';
import '../../bytes_helper/list_helper.dart';
import '../../bytes_helper/string_helper.dart';
import '../../serializer.dart';

final class Net implements Serializer {
  Net.deserialize(Iterator<int> iterator)
  : this._internal(
    length: iterator.read(4).toUint32(),
    iterator: iterator,
  );

  Net._internal({
    required int length,
    required Iterator<int> iterator,
  })
  : index = iterator.read(4).toUint32(),
    name = iterator.read(length - 8).toString8();

  final int index;
  final String name;

  @override
  List<int> serialize() => [
    ...(name.length + 8).toUint32List(),
    ...index.toUint32List(),
    ...name.toString8List(),
  ];
}
