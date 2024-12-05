// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'shareable/int_helper.dart';
import 'shareable/iterator_helper.dart';
import 'shareable/list_helper.dart';
import 'shareable/serializer.dart';

final class Net implements Serializer {
  Net._({
    required this.index,
    required this.name,
  });

  factory Net.deserialize(Iterator<int> iterator) {
    final length = iterator.read(4).toUint32();
    final index = iterator.read(4).toUint32();
    final name = iterator.read(length - 8).toString8();

    return Net._(
      index: index,
      name: name,
    );
  }

  final int index;
  final String name;

  @override
  List<int> serialize() => [
    ...(name.length + 8).toUint32List(),
    ...index.toUint32List(),
    ...utf8.encode(name),
  ];
}
