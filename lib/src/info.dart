// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'shareable/int_helper.dart';
import 'shareable/iterator_helper.dart';
import 'shareable/list_helper.dart';
import 'shareable/serializer.dart';

final class Info implements Serializer {
  const Info({
    required this.type,
    required this.bytes,
  });

  factory Info.deserialize(Iterator<int> iterator) {
    final type = iterator.read(1).first;
    final length = iterator.read(4).toUint32();
    final content = iterator.read(length);

    return Info(
      type: type,
      bytes: content,
    );
  }

  final int type;
  final List<int> bytes;

  @override
  List<int> serialize() => [
    type,
    ...bytes.length.toUint32List(),
    ...bytes,
  ];
}
