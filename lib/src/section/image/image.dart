// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import '../../shareable/int_helper.dart';
import '../../shareable/iterator_helper.dart';
import '../../shareable/list_helper.dart';
import '../../shareable/serializer.dart';

final class Image implements Serializer {
  const Image._({
    required this.id,
    required this.index,
    required this.flag,
    required this.sizeX,
    required this.sizeY,
    required this.name,
  });

  factory Image.deserialize(Iterator<int> iterator) {
    final id = iterator.read(1).first;
    final index = iterator.read(1).first;
    final flag = iterator.read(1).first;
    final sizeX = iterator.read(4).toUint32();
    final sizeY = iterator.read(4).toUint32();
    final length = iterator.read(4).toUint32();
    final name = iterator.read(length).toString8();

    return Image._(
      id: id,
      index: index,
      flag: flag,
      sizeX: sizeX,
      sizeY: sizeY,
      name: name,
    );
  }

  final int id;
  final int index;
  final int flag;
  final int sizeX;
  final int sizeY;
  final String name;

  @override
  List<int> serialize() => [
    id,
    index,
    flag,
    ...sizeX.toUint32List(),
    ...sizeY.toUint32List(),
    ...name.length.toUint32List(),
    ...utf8.encode(name),
  ];
}
