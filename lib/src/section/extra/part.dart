// Copyright 2024. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed
// by a BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import '../../bytes_helper/list_helper.dart';
import '../../serializable/bytes.dart';
import '../../serializable/bytesable.dart';
import '../../serializable/jsonable.dart';
import '../../serializable/text.dart';
import 'content.dart';
import 'resistance_type.dart';
import 'text_type.dart';

sealed class Part<T> implements Bytesable, Jsonable {
  const Part(this._contents);

  final List<T> _contents;

  @override
  bool operator ==(Object other) =>
    other is Part &&
    listEqual(other._contents, _contents);

  @override
  int get hashCode => Object.hashAll(_contents);
}

final class Part1<Content> extends Part {
  const Part1(super._contents);

  @override
  Bytes toBytes() => toJson().toBytes();

  @override
  JsonMap toJson() => {
    'part': _contents
      .map((e) => e as Jsonable)
      .map((e) => e.toJson())
      .toList()
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Part1 &&
    listEqual(other._contents, _contents);

  @override
  int get hashCode => Object.hashAll(_contents);
}

final class Part2<ResistanceType> extends Part {
  const Part2(super._contents);

  @override
  Bytes toBytes() => [
    for (final content in _contents)
    ...content.toBytes(),
  ];

  @override
  JsonMap toJson() => {
    'part': _contents
      .map((e) => e as Jsonable)
      .map((e) => e.toJson())
      .toList()
  }.toJsonMap();

  @override
  bool operator ==(Object other) =>
    other is Part2 &&
    listEqual(other._contents, _contents);

  @override
  int get hashCode => Object.hashAll(_contents);
}

extension PartOnBytes on Bytes {
  Part1 toPart1() => iterator.toPart1();

  Part2 toPart2() => iterator.toPart2();
}

extension PartOnIterator on Iterator<int> {
  Part1 toPart1() {
    final json = toBytes().toText();
    final map = jsonDecode(json) as Map<String, Object?>;

    return map.toPart1();
  }

  Part2 toPart2() {
    final items = <ResistanceType>[];
    for (;;) {
      try {
        final item = toTextType().toResistanceType();
        items.add(item);
      } on TextTypeNotFoundException {
        return Part2(items);
      }
    }
  }
}

extension PartOnJsonMap on JsonMap {
  Part1 toPart1() => toObject().toPart1();
  Part2 toPart2() => toObject().toPart2();
}

extension PartOnMap on Map<String, Object?> {
  Part1 toPart1() => Part1(
    (this['part']! as List<Object?>)
      .map((e) => e! as Map<String, Object?>)
      .map((e) => e.toContent())
      .toList(),
  );

  Part2 toPart2() => Part2(
    (this['part']! as List<Object?>)
      .map((e) => e! as Map<String, Object?>)
      .map((e) => e.toResistanceType())
      .toList()
  );
}
